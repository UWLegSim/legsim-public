class AddPaymentTokenToUser < ActiveRecord::Migration[4.2]
  def self.up
    add_column :users, :payment_token, :string
    add_column :users, :payment_ref, :string
  end

  def self.down
    remove_column :users, :payment_token
    remove_column :users, :payment_ref
  end
end
