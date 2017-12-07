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
    self.room.user_rooms.users_read_message(user,self).count
  end
end
