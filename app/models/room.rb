class Room < ApplicationRecord
  has_many :messages
  has_many :user_rooms, inverse_of: :room
  has_many :users, through: :user_rooms
  accepts_nested_attributes_for :user_rooms
  validates :create_user_id, presence: true
  validate :check_empty_room?, on: :create
  validate :check_dup_room?, on: :create, if: :check_empty_room?
  attr_accessor :current_user

  scope :sort_by_message_created, -> do
    includes(:messages).order("messages.created_at desc")
  end

  scope :check_available, -> (state) do
    joins(:user_rooms).where(user_rooms:{available_flag: state})
  end

  def check_empty_room?
    match_array = user_rooms.map(&:user_id)
    match_array.delete(current_user.id)
    if !match_array.empty?
      true
    else
      errors[:base] << 'No one is selected as room participant.'
      false
    end
  end

  def check_dup_room?
    check_flag = true
    match_array = user_rooms.map(&:user_id)
    current_user.rooms.check_available(true).each do |room|
      check_flag = false if match_array.sort == room.users.ids.sort
    end
    errors[:base] << 'Participant combination is overlapped.' unless check_flag
    check_flag
  end
end
