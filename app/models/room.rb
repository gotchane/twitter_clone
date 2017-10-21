class Room < ApplicationRecord
  validates :create_user_id, presence: true
  has_many :messages
  has_many :user_rooms
  has_many :users, through: :user_rooms
end
