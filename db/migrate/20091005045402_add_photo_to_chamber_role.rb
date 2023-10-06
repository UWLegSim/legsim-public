class AddPhotoToChamberRole < ActiveRecord::Migration[4.2]
  def self.up
    add_column :chamber_roles, :photo_file_name,    :string
    add_column :chamber_roles, :photo_content_type, :string
    add_column :chamber_roles, :photo_file_size,    :integer
    add_column :chamber_roles, :photo_updated_at,   :datetime
  end

  def self.down
    remove_column :chamber_roles, :photo_file_name
    remove_column :chamber_roles, :photo_content_type
    remove_column :chamber_roles, :photo_file_size
    remove_column :chamber_roles, :photo_updated_at
  end
end
