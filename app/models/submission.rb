# frozen_string_literal: true

class Submission < ApplicationRecord
  has_one :foi_request, dependent: :destroy

  validates :state, presence: true
end
