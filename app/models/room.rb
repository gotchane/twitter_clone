class Room < ApplicationRecord
  has_many :messages
  has_many :user_rooms, inverse_of: :room
  has_many :users, through: :user_rooms
  accepts_nested_attributes_for :user_rooms
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
    check_empty_array = match_array
    check_empty_array.delete(create_room_user.id)
    if !check_empty_array.empty?
      true
    else
      errors[:base] << 'No one is selected as room participant.'
      false
    end
  end

  def check_dup_room?
    check_flag = true
    create_room_user.rooms.check_available(true).each do |room|
      check_flag = false if match_array.sort == room.users.ids.sort
    end
    errors[:base] << 'Participant combination is overlapped.' unless check_flag
    check_flag
  end

  def delete_messages_history(user)
    user_rooms.find_by(user: user)
              .update_attributes(available_flag: false, last_history_deleted: DateTime.now)
  end

  private
    def create_room_user
      user_rooms.find { |user_room| user_room[:user_id] == create_user_id }.user
    end

    def match_array
      user_rooms.map(&:user_id)
    end
end
