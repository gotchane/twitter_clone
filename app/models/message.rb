class Message < ApplicationRecord
  validates :body, presence: true, length: {maximum: 500}
  validates :room_id, presence: true
  validates :user_id, presence: true
  belongs_to :room
  belongs_to :user
  after_create :room_reactivate_participant
  after_create :mark_last_read_my_message

  scope :after_history_deletion, -> (datetime) do
    where("messages.created_at > ?", datetime)
  end

  def room_reactivate_participant
    self.room.reactivate_participant
  end

  def mark_last_read_my_message
    mark_last_read_message(self.user)
  end

  def mark_last_read_message(user)
    user_room = self.room.user_rooms.find_by(user: user)
    user_room.mark_read_message(self)
  end

  def read_count(user)
    read_count = 0
    latest_read_message_ids = self.room.user_rooms
                                          .where.not(user_id: user.id)
                                          .map(&:latest_read_message_id)
    latest_read_message_ids.each do |latest_read_message_id|
      read_count += 1 if self.id.to_i <= latest_read_message_id.to_i
    end
    read_count
  end
end
