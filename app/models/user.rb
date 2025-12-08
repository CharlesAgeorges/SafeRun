class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :runs, dependent: :destroy
  has_many :guardians, dependent: :destroy
  has_many :run_badges, through: :runs
  has_many :incidents, through: :runs
end
