class Comment < ActiveRecord::Base
	belongs_to :micropost
	belongs_to :user
	validates :user_id, presence: true
	validates :micropost_id, presence: true
  validates :comment, presence: true, length: { maximum: 140 }
end
