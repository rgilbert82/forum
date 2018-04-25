class TopicSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :slug, :created_at
  has_many :posts, include: true
  has_many :votes, include: true
  has_many :topic_saves, include: true
  belongs_to :user, include: true
  belongs_to :forum, include: true
end
