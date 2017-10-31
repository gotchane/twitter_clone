class UserRoom < ApplicationRecord
  belongs_to :user
  belongs_to :room, inverse_of: :user_rooms
  validates :user_id, presence: true
  validates :room, presence: true, uniqueness: { scope: :user_id }

end
