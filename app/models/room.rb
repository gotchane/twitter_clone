class Room < ApplicationRecord
  validates :create_user_id, presence: true
  has_many :messages
  has_many :user_rooms, inverse_of: :room
  has_many :users, through: :user_rooms
  accepts_nested_attributes_for :user_rooms
  validate :check_dup_room?

  scope :sort_by_message_created, -> do
    includes(:messages).order("messages.created_at desc")
  end

  scope :check_available, -> (state) do
    joins(:user_rooms).where(user_rooms:{available_flag: state})
  end

  def unavailable_participant?
    count = user_rooms.where(user_rooms:{available_flag: false}).count
    count != 0 ? true : false
  end

  def reactivate_participant
    user_rooms.update_all(available_flag: true)
  end

  def check_dup_room?
    check_flag = true
    match_array = self.user_rooms.map(&:user_id)
    User.find(self.create_user_id).rooms.check_available(true).each do |room|
      check_flag = false if match_array.sort == room.users.ids.sort
    end
    self.errors[:base] << 'Participant combination is overlapped.' unless check_flag
    check_flag
  end
end
