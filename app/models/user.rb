class User < ActiveRecord::Base
  include Sluggable

  has_many :forums, dependent: :destroy
  has_many :topics, dependent: :destroy
  has_many :posts, dependent: :destroy
  has_many :topic_saves, dependent: :destroy
  has_many :votes, dependent: :destroy
  has_many :sent_conversations, class_name: "Conversation", foreign_key: :sender_id, dependent: :destroy
  has_many :received_conversations, class_name: "Conversation", foreign_key: :recipient_id, dependent: :destroy
  has_many :messages, dependent: :destroy

  validates_presence_of :username
  validates_presence_of :password
  validates_uniqueness_of :username

  has_secure_password validations: false

  sluggable_column :username
  before_create :generate_token!

  def generate_token!
    self.token = SecureRandom.urlsafe_base64(20)
  end

  def regenerate_token!
    self.update_column(:token, SecureRandom.urlsafe_base64(20))
  end
end
