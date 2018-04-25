class PostSerializer < ActiveModel::Serializer
  attributes :body, :editable, :created_at
  has_many :replies, include: true
  belongs_to :parent, class_name: "Post", include: true
  belongs_to :user, include: true
  belongs_to :topic, include: true
end
