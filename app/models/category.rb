class Category < ActiveRecord::Base
  attr_accessible :name, :description, :parent_id, :lft, :rgt, :vision, :progress,:blueprint_id, :master_map_id
  acts_as_nested_set
  
  belongs_to :blueprint
  belongs_to :master_map
end
