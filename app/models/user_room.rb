class UserRoom < ApplicationRecord
  belongs_to :user
  belongs_to :room, inverse_of: :user_rooms
  validates :user_id, presence: true
  validates :room, presence: true, uniqueness: { scope: :user_id }

  def delete_messages_history
    update_attributes(available_flag: false, last_history_deleted: DateTime.now)
  end

  def datetime_last_history_deleted
    last_history_deleted.nil? ? created_at : last_history_deleted
  end
end
