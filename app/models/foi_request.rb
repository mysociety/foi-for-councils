# frozen_string_literal: true

class FoiRequest < ApplicationRecord
  belongs_to :contact, optional: true, dependent: :destroy
  belongs_to :submission, optional: true, dependent: :destroy

  validates :body, presence: true
end
