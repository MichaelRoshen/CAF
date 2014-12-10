#encoding: utf-8
require "securerandom"
class User
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::BaseModel
  
  ALLOW_LOGIN_CHARS_REGEXP = /\A\w+\z/

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

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
  field :bio #简介
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

  # has_many :topics, dependent: :destroy
  # has_many :notes
  # has_many :replies, dependent: :destroy
  # embeds_many :authorizations
  # has_many :notifications, class_name: 'Notification::Base', dependent: :delete
  # has_many :photos

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
