class CreateMasterMaps < ActiveRecord::Migration
  def self.up
    create_table :master_maps do |t|
      t.string :name
      t.text :description
      t.string :created_by
      t.timestamps
    end
  end

  def self.down
    drop_table :master_maps
  end
end
