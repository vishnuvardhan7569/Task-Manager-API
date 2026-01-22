class User < ApplicationRecord
  has_secure_password

  has_many :projects, dependent: :destroy
  has_many :tasks, through: :projects

  before_validation { self.email = email.downcase if email.present? }

  validates :email, presence: true, uniqueness: true
end
