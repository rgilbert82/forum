class MessageSerializer < ActiveModel::Serializer
  attributes :body, :unread, :created_at

  belongs_to :conversation, include: true
  belongs_to :user, include: true
end
