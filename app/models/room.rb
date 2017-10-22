class Room < ApplicationRecord
  validates :create_user_id, presence: true
  has_many :messages
  has_many :user_rooms
  has_many :users, through: :user_rooms

  scope :sort_by_message_created, -> do
    includes(:messages).order("messages.created_at desc")

  end

  scope :check_available, -> do
    includes(:user_rooms).where("user_rooms.available_flag = ?", true)
  end

  def check_dup_combination(user_room_params)
    current_user.rooms.each do |room|
      if user_room_params.count == room.users.count - 1 then
        match_array = user_room_params.map(&:to_i)
        match_array << current_user.id
        if match_array.sort == room.users.ids.sort then
          redirect_to new_user_room_path(current_user), danger: "Participant combination is overlapped."
          return
        end
      end
    end
  end

  def delete_messages_history(user)
    self.user_rooms.find_by(user_id: user.id).update_attributes(available_flag: false)
  end

  def unavailable_participant?
    count = self.user_rooms.where("user_rooms.available_flag = ?", false).count
    count != 0 ? true : false
  end

  def reactivate_participant
    self.user_rooms.update_all(available_flag: true)
  end
end
