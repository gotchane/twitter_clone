class Room < ApplicationRecord
  validates :create_user_id, presence: true
  has_many :messages
  has_many :user_rooms
  has_many :users, through: :user_rooms

  scope :sort_by_message_created, -> do
    includes(:messages).order("messages.created_at desc")
  end

  scope :check_available, -> do
    joins(:user_rooms).where(user_rooms:{available_flag: true})
  end

  def delete_messages_history(user)
    self.user_rooms.find_by(user: user)
                   .update_attributes(
                     available_flag: false,
                     last_history_deleted: DateTime.now
                    )
  end

  def unavailable_participant?
    count = self.user_rooms.where(user_rooms:{available_flag: false}).count
    count != 0 ? true : false
  end

  def reactivate_participant
    self.user_rooms.update_all(available_flag: true)
  end
end
