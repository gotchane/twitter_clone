class User < ApplicationRecord
  #has_secure_password validations: true
  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :password, presence: true, length: { minimum: 6 }
  has_secure_password
  has_many :tweets
  default_scope -> { order(created_at: :desc) }
end
