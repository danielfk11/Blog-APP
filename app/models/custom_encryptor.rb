require 'bcrypt'

class CustomEncryptor < Devise::Encryptable::Encryptor
  def self.digest(password, stretches, salt, pepper)
    ::BCrypt::Password.create([password, salt].join, cost: stretches)
  end

  def self.compare(encrypted_password, password, stretches, salt, pepper)
    bcrypt   = ::BCrypt::Password.new(encrypted_password)
    password = ::BCrypt::Engine.hash_secret([password, salt].join, bcrypt.salt)
    Devise.secure_compare(encrypted_password, password)
  end
end
