require 'bcrypt'

class User < ApplicationRecord
  has_secure_password
  
  validates :email, presence: true, uniqueness: { case_sensitive: false }
  validates :name, presence: true
  validates :matricula, presence: true, uniqueness: true
  validates :role, presence: true
  
  before_save { self.email = email.downcase }
end
