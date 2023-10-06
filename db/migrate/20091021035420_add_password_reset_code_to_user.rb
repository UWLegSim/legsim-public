class AddPasswordResetCodeToUser < ActiveRecord::Migration[4.2]
  def self.up
    add_column :users, :password_reset_code, :string, :limit => 40
  end

  def self.down
    remove_column :users, :password_reset_code
  end
end
