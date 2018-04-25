class Forum < ActiveRecord::Base
  include Sluggable

  belongs_to :user
  has_many :topics, :dependent => :destroy

  validates_presence_of :name

  sluggable_column :name
end
