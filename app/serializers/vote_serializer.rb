class VoteSerializer < ActiveModel::Serializer
  attribute :vote

  belongs_to :user, include: true
  belongs_to :topic, include: true
end
