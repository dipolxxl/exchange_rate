class Currency < ActiveRecord::Base
  has_many :rates
  #attr_accessible :code, :name
end
