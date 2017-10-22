class Message < ApplicationRecord
  validates :body, presence: true, length: {maximum: 500}
  validates :room_id, presence: true
  validates :user_id, presence: true
  belongs_to :room
  belongs_to :user

end
