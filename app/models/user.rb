class User < ApplicationRecord
  attr_accessor :updating_password
  has_many :posts, dependent: :destroy

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :username, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true, format: { with: /\A[^@\s]+@(?:[^@\s]+\.)+[a-z]{2,}\z/i }
  validates :phone_number, presence: true, uniqueness: { case_sensitive: false }, format: { with: /\A\+55\d{2}\d{9}\z/, message: "Insira um número de telefone brasileiro válido (Ex: +5521999999999)" }
  validates :password, presence: true, length: { minimum: 8 }, if: :password_required?
  validates :password_confirmation, presence: true, if: :password_required?

  def authenticate(password)
    return false unless self.encrypted_password.present?
    BCrypt::Password.new(self.encrypted_password) == password
  end

  private

  def password_required?
    return false if updating_password == false
    return true if new_record? || password.present? || password_confirmation.present?
    false
  end

  def password_match
    return if password.blank? || password_confirmation.blank?
    unless password == password_confirmation
      errors.add(:password_confirmation, 'deve estar igual à senha')
    end
  end
end
