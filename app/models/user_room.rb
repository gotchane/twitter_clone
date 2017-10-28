class UserRoom < ApplicationRecord
  belongs_to :user
  belongs_to :room
  validates :user_id, presence: true
  validates :room_id, presence: true, uniqueness: { scope: :user_id }

  def mark_last_read_message(message)
    update_attributes(latest_read_message_id: message.id)
  end

  def datetime_last_history_deleted
    self.last_history_deleted.nil? ? self.created_at : self.last_history_deleted
  end
end
