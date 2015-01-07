#encoding: utf-8
require "securerandom"
class Team
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::BaseModel
  

  ALLOW_LOGIN_CHARS_REGEXP = /[0-9A-Za-z\u4e00-\u9fa5\_]{2,14}/
  
  #默认球队介绍
  DEFAULT_TEAM_BIO = "    皇家马德里足球俱乐部（Real Madrid Club de Fútbol ，中文简称为皇马）是一家位于西班牙马德里的足球俱乐部，球队成立于1902年3月6日，前称马德里足球队。1920年获国王赐封“皇家”的尊称，徽章上加上了皇冠，并改名为皇家马德里。皇家马德里足球俱乐部，拥有众多世界球星。2000年12月11日被国际足球联合会（FIFA）评为20世纪最伟大的球队。2009年9月10日被国际足球历史和统计联合会评为20世纪欧洲最佳俱乐部。2014年9月10日被评为2014年度欧洲最佳俱乐部。"
  #默认球队文化
  DEFAULT_TEAM_CULTURE = ""
  #默认球队荣誉
  DEFAULT_TEAM_HONOR = ""
  validates :name, format: { with: ALLOW_LOGIN_CHARS_REGEXP, message: '只允许汉字,英文,数字,下划线'}, 
                              length: {:in => 2..14}, presence: true, 
                              uniqueness: {case_sensitive: false}

  field :name #球队名称
  field :qq
  field :coach #教练
  field :captain #队长
  field :mobile_phone
  field :location #地区
  field :territory #活动范围
  field :bio, default: DEFAULT_TEAM_BIO #球队简介
  field :culture, default: DEFAULT_TEAM_CULTURE #球队文化
  field :honor, default: DEFAULT_TEAM_HONOR #球队荣誉
  field :company #所属公司
  field :creater_id #创建者
  # 是否信任用户
  field :state, type: Integer, default: 1

  mount_uploader :avatar, TeamAvatarUploader

  # has_many :topics, dependent: :destroy
  # has_many :notes
  # has_many :replies, dependent: :destroy
  # embeds_many :authorizations
  # has_many :notifications, class_name: 'Notification::Base', dependent: :delete
  has_and_belongs_to_many :admins, :class_name=>'User',:inverse_of=>:admin_of
  has_and_belongs_to_many :members, :class_name=>'User',:inverse_of=>:member_of

  def user_count
    admins.size + members.size    
  end
  
  def creater_name
    User.find(self.creater_id).try(:login)
  end

  def avatar_file_exist?
    File::exists?(Rails.root.to_s + "/public/#{self.avatar_url}")
  end

end
