class Post < ActiveRecord::Base
  belongs_to :user
  belongs_to :topic

  belongs_to :parent, class_name: "Post", optional: true
  has_many :replies, class_name: "Post", foreign_key: "parent_id"
end
