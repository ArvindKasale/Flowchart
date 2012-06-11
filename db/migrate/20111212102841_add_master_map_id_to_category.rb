class AddMasterMapIdToCategory < ActiveRecord::Migration
  def self.up
    add_column :categories, :master_map_id, :integer
  end

  def self.down
    remove_column :categories, :master_map_id
  end
end
