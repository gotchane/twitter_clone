class UserRoom < ApplicationRecord
  belongs_to :user
  belongs_to :room
  validates :user_id, presence: true
  validates :room_id, presence: true, uniqueness: { scope: :user_id }

  def self.update_latest_read_message(room,user)
    room.user_rooms.find_by(user: user)
                   .update_attributes(
                     latest_read_message_id: room.messages.order(created_at: :desc).first.id
                   ) unless room.messages.count == 0
  end

  def datetime_last_history_deleted
    self.last_history_deleted.nil? ? self.created_at : self.last_history_deleted
  end
end
