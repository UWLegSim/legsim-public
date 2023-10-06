class CreatePayments < ActiveRecord::Migration[6.0]
  def change
    create_table :payments do |t|
      t.integer  :user_id
      t.string   :payment_type
      t.integer  :amount
      t.datetime :processed_at
      t.string   :transaction_id
      t.string   :approval_code
      t.string   :status
      t.string   :cc_number
      t.boolean  :test
      t.timestamps
    end
  end
end
