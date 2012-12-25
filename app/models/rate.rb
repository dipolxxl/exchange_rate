# == Schema Information
#
# Table name: rates
#
#  id          :integer          not null, primary key
#  course      :float
#  month       :date
#  currency_id :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Rate < ActiveRecord::Base
  belongs_to :currency
  attr_accessible :course, :month

  private

  scope :at_month, ->(date){includes(:currency).where(month: date.beginning_of_month)}
end