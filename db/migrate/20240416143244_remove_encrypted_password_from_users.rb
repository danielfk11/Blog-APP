class RemoveEncryptedPasswordFromUsers < ActiveRecord::Migration[7.1]
  def change
    remove_column :users, :encrypted_password
  end
end
