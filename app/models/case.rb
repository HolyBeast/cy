class Case < ActiveRecord::Base
  attr_accessible :x, :y
  has_one :map
  
end