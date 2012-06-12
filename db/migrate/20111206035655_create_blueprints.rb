class CreateBlueprints < ActiveRecord::Migration
  def self.up
    create_table :blueprints do |t|
      t.string :name
      t.string :node_type, :default=>"circle"
      t.string :color, :default=>"#F27713"
      t.integer :vision, :default=>0

      t.timestamps
    end
  end

  def self.down
    drop_table :blueprints
  end
end
