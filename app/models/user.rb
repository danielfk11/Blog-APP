require 'bcrypt'

class User < ApplicationRecord
  has_many :posts, dependent: :destroy

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :username, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :phone_number, presence: true, uniqueness: { case_sensitive: false }, format: { with: /\A\+55\d{2}\d{9}\z/, message: "Insira um número de telefone brasileiro válido (Ex: +5521999999999)" }
  validates :password, presence: true, length: { minimum: 8, message: "A senha deve ter no mínimo 8 caracteres, 1 caractere especial e 1 número" }, if: :password_required?
  validates :password_confirmation, presence: true, if: :password_required?

  def authenticate(password)
    return false unless self.encrypted_password.present?
    BCrypt::Password.new(self.encrypted_password) == password
  end

  private

  def password_required?
    new_record? || password.present? || password_confirmation.present?
  end

  def password_match
    errors.add(:password_confirmation, "deve estar igual à senha") if password != password_confirmation
  end
end
