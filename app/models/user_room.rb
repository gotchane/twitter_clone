class UserRoom < ApplicationRecord
  belongs_to :user
  belongs_to :room
  validates :user_id, presence: true
  validates :room_id, presence: true, uniqueness: { scope: :user_id }

  def self.update_latest_read_message(room,user)
    room.user_rooms.find_by(user_id: user.id)
                   .update_attributes(
                     latest_read_message_id: room.messages.order(created_at: "DESC").first.id
                   )
  end
end
