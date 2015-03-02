# coding: utf-8
require "digest/md5"
class Reply
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::BaseModel
  include Mongoid::CounterCache
  # include Mongoid::SoftDelete
  # include Mongoid::MarkdownBody
  # include Mongoid::Mentionable
  # include Mongoid::Likeable

  field :body
  field :body_html
  field :source
  field :message_id

  belongs_to :user, inverse_of: :replies
  belongs_to :topic, inverse_of: :replies, touch: true
  # has_many :notifications, class_name: 'Notification::Base', dependent: :delete

  counter_cache name: :user, inverse_of: :replies
  counter_cache name: :topic, inverse_of: :replies

  index user_id: 1
  index topic_id: 1

  delegate :title, to: :topic, prefix: true, allow_nil: true
  delegate :login, to: :user, prefix: true, allow_nil: true

  validates_presence_of :body
  validates_uniqueness_of :body, scope: [:topic_id, :user_id], message: "不能重复提交。"

  after_save :update_parent_topic
  def update_parent_topic
    topic.update_last_reply(self)
  end

  # 删除的时候也要更新 Topic 的 updated_at 以便清理缓存
  after_destroy :update_parent_topic_updated_at
  def update_parent_topic_updated_at
    if not self.topic.blank?
      self.topic.update_deleted_last_reply(self)
      true
    end
  end

  def self.per_page
    50
  end

  # 是否热门
  def popular?
    self.likes_count >= 5
  end

  def destroy
    super
    # notifications.delete_all
    # delete_notifiaction_mentions
  end
end
