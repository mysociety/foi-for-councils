# frozen_string_literal: true

# == Schema Information
#
# Table name: performances
#
#  id         :bigint           not null, primary key
#  percentage :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null

##
# This model represents the performance percentage of the organisation.
#
class Performance < ApplicationRecord
  validates :percentage, presence: true, numericality: {
    only_integer: true,
    greater_than_or_equal_to: 0,
    less_than_or_equal_to: 100,
    message: 'must be between 0 and 100'
  }

  default_scope -> { order(:created_at) }

  def self.current_percentage
    last&.percentage
  end
end
