class AddVisionToCategory < ActiveRecord::Migration
  def self.up
    add_column :categories, :vision, :integer, :default=> 0
  end

  def self.down
    remove_column :categories, :vision
  end
end
