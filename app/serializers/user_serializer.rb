class UserSerializer < ActiveModel::Serializer
  attributes :username, :slug, :admin, :created_at
  has_many :forums, include: true
  has_many :topics, include: true
  has_many :posts, include: true
  has_many :votes, include: true
  has_many :topic_saves, include: true
  has_many :sent_conversations, include: true
  has_many :received_conversations, include: true
  has_many :messages, include: true
end
