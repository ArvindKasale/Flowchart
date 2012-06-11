class MasterMap < ActiveRecord::Base
  
  has_many :categories, :dependent=>:destroy
  
end
