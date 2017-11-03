class Message < ApplicationRecord
  validates :body, presence: true, length: {maximum: 500}
  validates :room_id, presence: true
  validates :user_id, presence: true
  belongs_to :room
  belongs_to :user
  after_save :room_reactivate_participant
  after_save -> { mark_last_read_message(self.user) }

  scope :after_history_deletion, -> (datetime) do
    where("messages.created_at > ?", datetime)
  end

  def room_reactivate_participant
    self.room.reactivate_participant
  end

  def mark_last_read_message(user)
    self.room.user_rooms.find_by(user: user)
                   .update_attributes(latest_read_message_id: self.id) unless self.nil?
  end
end
