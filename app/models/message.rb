class Message < ApplicationRecord
  validates :body, presence: true, length: {maximum: 500}
  validates :room_id, presence: true
  validates :user_id, presence: true
  belongs_to :room
  belongs_to :user
  after_save :reactivate_participant
  after_save -> { mark_last_read_message(self.user) }

  scope :after_history_deletion, -> (datetime) do
    where("messages.created_at > ?", datetime)
  end

  def unavailable_participant?
    count = room.user_rooms.where(user_rooms:{available_flag: false}).count
    count != 0 ? true : false
  end

  def reactivate_participant
    room.user_rooms.update_all(available_flag: true) if unavailable_participant?
  end

  def mark_last_read_message(user)
    room.user_rooms.find_by(user: user)
                   .update_attributes(latest_read_message_id: self.id) unless self.nil?
  end
end
