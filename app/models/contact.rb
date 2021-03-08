# frozen_string_literal: true

require 'mysociety/validate'

# == Schema Information
#
# Table name: contacts
#
#  id         :bigint           not null, primary key
#  email      :string           not null
#  full_name  :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null

##
# This model represents a contact details of an user.
#
class Contact < ApplicationRecord
  has_one :foi_request, dependent: :destroy

  validates :email, :full_name, presence: true
  validates :email, format: {
    with: /\A#{MySociety::Validate.email_match_regexp}\z/
  }
end
