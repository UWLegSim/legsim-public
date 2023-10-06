class AddPaymentOptionToCourses < ActiveRecord::Migration[4.2]
  def self.up
    add_column :courses, :payment_option, :string, :default => 'prepaid'
  end

  def self.down
    remove_column :courses, :payment_option
  end
end
