class UserRoom < ApplicationRecord
  belongs_to :user
  belongs_to :room
  validates :user_id, presence: true
  validates :room_id, presence: true, uniqueness: { scope: :user_id }

  def mark_last_read_message(message)
    update_attributes(latest_read_message_id: message.id) unless message.nil?
  end

  def delete_messages_history
    update_attributes(available_flag: false, last_history_deleted: DateTime.now)
  end

  def datetime_last_history_deleted
    last_history_deleted.nil? ? created_at : last_history_deleted
  end
end
