class AddScenerioToChambers < ActiveRecord::Migration[4.2]
  def self.up
    add_column :chambers, :scenerio, :string, :default => 'us_house_of_representatives'
  end

  def self.down
    remove_column :chambers, :scenerio
  end
end
