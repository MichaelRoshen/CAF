#encoding: utf-8
require "securerandom"
class User
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::BaseModel
  
  ALLOW_LOGIN_CHARS_REGEXP = /\A\w+\z/
  #个人介绍默认值
  DEFAULT_USER_BIO = "    1976年9月18日出生在巴西里约热内卢郊外的本托-里贝罗区。世界传奇前锋，绰号外星人，国家队大满贯多次荣获“最佳射手”、“最佳球员”等等荣誉。罗纳尔多曾三度当选世界足球先生、两度当选欧洲足球先生。作为20世纪末以及21世纪初最伟大的球员之一，引领了一个群星璀璨的足球时代。"

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  validates :login, format: { with: ALLOW_LOGIN_CHARS_REGEXP, message: '只允许数字,字母,下划线'}, 
                              length: {:in => 3..20}, presence: true, 
                              uniqueness: {case_sensitive: false}

  field :email, type: String, default: ""
  # Email 的 md5 值，用于 Gravatar 头像
  field :email_md5
  # Email 是否公开
  field :email_public, type: Mongoid::Boolean
  field :encrypted_password, type: String, default: ""

  ## Recoverable
  field :reset_password_token,   type: String
  field :reset_password_sent_at, type: Time

  ## Rememberable
  field :remember_created_at, type: Time

  ## Trackable
  field :sign_in_count,      type: Integer, default: 0
  field :current_sign_in_at, type: Time
  field :last_sign_in_at,    type: Time
  field :current_sign_in_ip, type: String
  field :last_sign_in_ip,    type: String

  field :login
  field :name
  field :qq
  field :mobile_phone
  field :location #地区
  field :territory #活动范围
  field :bio, default: DEFAULT_USER_BIO
  field :position #位置
  field :career #职业
  field :company #所在公司
  # 是否信任用户
  field :verified, type: Mongoid::Boolean, :default => false
  field :state, type: Integer, default: 1
  field :guest, type: Mongoid::Boolean, default: false
  field :tagline #签名
  field :topics_count, type: Integer, default: 0
  field :replies_count, type: Integer, default: 0
  # 用户密钥，用于客户端验证
  field :private_token
  field :favorite_topic_ids, type: Array, default: []

  mount_uploader :avatar, AvatarUploader

  index login: 1
  index email: 1
  index location: 1
  index({private_token: 1},{ sparse: true })
  has_many :photos
  has_many :topics, dependent: :destroy
  # has_many :notes
  # has_many :replies, dependent: :destroy
  # embeds_many :authorizations
  # has_many :notifications, class_name: 'Notification::Base', dependent: :delete
  has_and_belongs_to_many :admin_of,  class_name: "Team"
  has_and_belongs_to_many :member_of, class_name: "Team"

  def has_role?(role)
    case role
      when :admin then admin?
      when :member then self.state == STATE[:normal]
      else false
    end
  end

  def admin?
    true
  end

  def own_team
    Team.where(creater_id: self.id).first
  end

  def had_create_a_team?
    Team.where(creater_id: self.id).first.present?
  end

  def avatar_file_exist?
    File::exists?(Rails.root.to_s + "/public/#{self.avatar_url}")
  end

  def self.find_login(slug)
    # FIXME: Regexp search in MongoDB is slow!!!
    where(login: /^#{slug}$/i).first
  end

  class << self
    def serialize_from_session(key, salt)
      record = to_adapter.get(key[0]["$oid"])
      record if record && record.authenticatable_salt == salt
    end
  end

# 重新生成 Private Token
  def update_private_token
    random_key = "#{SecureRandom.hex(10)}:#{self.id}"
    self.update_attribute(:private_token, random_key)
  end

  def ensure_private_token!
    self.update_private_token if self.private_token.blank?
  end

end
