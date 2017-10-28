class Room < ApplicationRecord
  validates :create_user_id, presence: true
  has_many :messages
  has_many :user_rooms, inverse_of: :room
  has_many :users, through: :user_rooms
  accepts_nested_attributes_for :user_rooms

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
end
