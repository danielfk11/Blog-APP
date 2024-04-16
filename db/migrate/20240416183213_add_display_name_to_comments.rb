class AddDisplayNameToComments < ActiveRecord::Migration[7.1]
  def change
    add_column :comments, :display_name, :string
  end
end
