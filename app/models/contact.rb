# frozen_string_literal: true

class Contact < ApplicationRecord
  has_one :foi_request, dependent: :destroy

  validates :email, :full_name, presence: true
end
