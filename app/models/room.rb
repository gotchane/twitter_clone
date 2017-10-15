class Room < ApplicationRecord
  validates :create_user_id, presence: true
  has_many :messages
end
