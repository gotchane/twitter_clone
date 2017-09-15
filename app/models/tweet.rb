class Tweet < ApplicationRecord
  belongs_to :user
  validates :user_id, presence: true
  validates :tweet_text, presence: true, length: { maximum: 140 }
end
