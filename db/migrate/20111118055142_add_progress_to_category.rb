class AddProgressToCategory < ActiveRecord::Migration
  def self.up
    add_column :categories, :progress, :integer, :default=> 0
  end

  def self.down
    remove_column :categories, :progress
  end
end
