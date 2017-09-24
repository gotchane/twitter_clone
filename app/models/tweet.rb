class Tweet < ApplicationRecord
  belongs_to :user
  validates :user_id, presence: true
  validates :tweet_text, presence: true, length: { maximum: 140 }
  default_scope -> { order(created_at: :desc) }
  mount_uploader :image, ImageUploader
  validate :image_size

  private
    def image_size
      if image.size > 2.megabytes
        errors.add(:image, "Please upload file under 2 MB.")
      end
    end
end
