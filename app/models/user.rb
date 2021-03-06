class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :trackable, :omniauthable, omniauth_providers: [:google_oauth2]

  has_many :swishes, dependent: :nullify
  has_many :swish_reports, through: :swishes, dependent: :nullify

  before_create :generate_api_key

  def generate_api_key
    self.api_key = SecureRandom.uuid
  end

  def display_name
    (name&.strip != "" ? name : email.split('@').first)&.truncate(13)
  end

  def admin?
    self.email == 'prikesh@rirev.com'
  end
end
