# == Schema Information
#
# Table name: currencies
#
#  id         :integer          not null, primary key
#  code       :string(255)
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Currency < ActiveRecord::Base
  has_many :rates
  attr_accessible :code, :name

  scope :at_code, ->(code){where(code: code)}
  scope :at_month, ->(date){where(month: date.beginning_of_month)}
end
