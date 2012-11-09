class Rate < ActiveRecord::Base
  belongs_to :currency
  #attr_accessible :course, :month
end
