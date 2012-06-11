class AddBlueprintIdToCategory < ActiveRecord::Migration
  def self.up
    add_column :categories, :blueprint_id, :integer
  end

  def self.down
    remove_column :categories, :blueprint_id
  end
end
