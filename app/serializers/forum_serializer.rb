class ForumSerializer < ActiveModel::Serializer
  attributes :id, :name, :slug
  has_many :topics, include: true
  belongs_to :user, include: true
end
