class Room < ApplicationRecord
  validates :create_user_id, presence: true
  has_many :messages
  has_many :user_rooms
  has_many :users, through: :user_rooms

  scope :sort_by_message_created, -> do
    includes(:messages).order("messages.created_at desc")

  end

end
