class Conversation < ActiveRecord::Base
  include Sluggable

  belongs_to :sender, class_name: "User", foreign_key: :sender_id
  belongs_to :recipient, class_name: "User", foreign_key: :recipient_id
  has_many :messages, dependent: :destroy

  validates_presence_of :title, :sender_id, :recipient_id

  sluggable_column :title
end
