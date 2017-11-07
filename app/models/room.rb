class Room < ApplicationRecord
  has_many :messages
  has_many :user_rooms, inverse_of: :room
  has_many :users, through: :user_rooms
  belongs_to :create_user, class_name:  "User"
  validates :create_user_id, presence: true
  validate :check_empty_room?, on: :create
  validate :check_dup_room?, on: :create, if: :check_empty_room?

  scope :sort_by_message_created, -> do
    includes(:messages).order("messages.created_at desc")
  end

  scope :check_available, -> (state) do
    joins(:user_rooms).where(user_rooms:{available_flag: state})
  end

  def check_empty_room?
    if !user_ids_without_me(self.user_ids).empty?
      true
    else
      errors[:base] << 'No one is selected as room participant.'
      false
    end
  end

  def check_dup_room?
    check_flag = false
    self.create_user.rooms.check_available(true).any? do |room|
      check_flag = same_participants?(room.users.ids)
    end
    unless check_flag
      true
    else
      errors[:base] << 'Participant combination is overlapped.'
      false
    end
  end

  def delete_messages_history(user)
    self.user_rooms.find_by(user: user).delete_history
  end

  def datetime_last_history_deleted(user)
    self.user_rooms.find_by(user: user).datetime_history_deleted
  end

  def last_read_msg_id(user)
    self.user_rooms.find_by(user: user).my_last_read_msg_id
  end

  def unavailable_participant?
    count = self.user_rooms.where(user_rooms:{available_flag: false}).count
    count != 0 ? true : false
  end

  def reactivate_participant
    self.user_rooms.update_all(available_flag: true) if self.unavailable_participant?
  end

  def existing_unused_room
    self.create_user.rooms.each do |room|
      if room.unavailable_participant? && same_participants?(room.users.ids)
        return room
      end
    end
    return nil
  end

  def has_unread_message?(user)
    room_latest_message_id = self.messages.order(id: :desc).first.id unless self.messages.count == 0
    latest_read_message_id = user.user_rooms.find_by(room: self).latest_read_message_id
    if self.messages.count != 0 && room_latest_message_id.to_i > latest_read_message_id.to_i
      true
    else
      false
    end
  end

  private
    def user_ids_without_me(user_ids)
      user_ids.reject { |user_id| user_id == self.create_user_id }
    end

    def same_participants?(room_user_ids)
      user_ids_without_me(self.user_ids).sort == user_ids_without_me(room_user_ids).sort
    end
end
