class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, presence: true
  validates :phone_number, presence: true,format: { with: /\A\+[1-9]\d{6,14}\z/, message: "Format Invalide" }

  validates :password,
          length: { minimum: 8 },
          format: {
            with: /\A(?=.*[a-z])(?=.*[A-Z])(?=.*\d).+\z/,
            message: "Min. 8 charactères dont une majuscule, une minuscule et un chiffre"
          },
          if: :password_required?

  has_many :runs, dependent: :destroy
  has_many :guardians, dependent: :destroy
  has_many :run_badges, through: :runs
  has_many :badges, through: :run_badges
  has_many :incidents, through: :runs

  private

  def password_required?
    !persisted? || password.present?
  end
end
