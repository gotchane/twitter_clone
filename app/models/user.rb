class User < ApplicationRecord
  before_save { self.email = email.downcase }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :name, presence: true
  validates :email, presence: true, uniqueness: true,
            length: {maximum: 255}, format: { with: VALID_EMAIL_REGEX }
  validates :profile, length: {maximum: 100}
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }, :if => :validate_password?
  has_many :tweets
  has_many :active_relationships,  class_name:  "Relationship",
                                   foreign_key: "follower_id",
                                   dependent:   :destroy
  has_many :passive_relationships, class_name:  "Relationship",
                                   foreign_key: "followed_id",
                                   dependent:   :destroy
  has_many :following, through: :active_relationships,  source: :followed
  has_many :followers, through: :passive_relationships, source: :follower
  has_many :user_rooms
  mount_uploader :avater, AvaterUploader

  def follow(other_user)
    active_relationships.create(followed: other_user)
  end

  def unfollow(other_user)
    active_relationships.find_by(followed: other_user).destroy
  end

  def following?(other_user)
    following.include?(other_user)
  end

  private
    def validate_password?
      password.present? || password_confirmation.present?
    end
end
