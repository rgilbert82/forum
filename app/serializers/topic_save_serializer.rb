class TopicSaveSerializer < ActiveModel::Serializer
  belongs_to :user, include: true
  belongs_to :topic, include: true
end
