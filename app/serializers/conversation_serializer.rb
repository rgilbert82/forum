class ConversationSerializer < ActiveModel::Serializer
  attributes :title, :sender_trash, :recipient_trash, :slug, :created_at

  has_many :messages, include: true
  belongs_to :sender, class_name: "User", include: true
  belongs_to :recipient, class_name: "User", include: true
end
