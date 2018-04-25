class Topic < ActiveRecord::Base
  include Sluggable

  belongs_to :user
  belongs_to :forum
  has_many :posts, dependent: :destroy
  has_many :topic_saves, dependent: :destroy
  has_many :votes, dependent: :destroy

  validates_presence_of :title
  validates_presence_of :body

  sluggable_column :title
end
