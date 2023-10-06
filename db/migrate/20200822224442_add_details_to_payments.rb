class AddDetailsToPayments < ActiveRecord::Migration[6.0]
  def change
    add_column :payments, :details, :text
  end
end
