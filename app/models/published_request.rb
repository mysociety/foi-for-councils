# frozen_string_literal: true

# == Schema Information
#
# Table name: published_requests
#
#  id              :bigint           not null, primary key
#  api_created_at  :datetime
#  case_management :string
#  keywords        :string
#  payload         :jsonb
#  published_at    :datetime
#  reference       :string
#  summary         :text
#  title           :string
#  url             :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

##
# A cache of published FOI requests and responses from the disclosure log.
#
class PublishedRequest < ApplicationRecord
  has_many :foi_suggestions, as: :resource, dependent: :destroy

  # Virtual accessor for Infreemation compatibility.
  # Infreemation provides all requests in the feed, so we need to check whether
  # they're publishable. If they are, then we update our cache; if not, we must
  # destroy it from our cache.
  attr_accessor :publishable

  scope :source, ->(source) { where(case_management: source.name) }

  def self.create_update_or_destroy_from_api!(request)
    record = find_or_initialize_by(reference: request.reference)
    record.assign_attributes(request.to_h)
    record.save_or_destroy!
    record
  end

  def url
    self[:url] || CaseManagement.generate_url(self)
  end

  def save_or_destroy!
    if publishable?
      save!
    else
      destroy!
    end
  end

  private

  def publishable?
    true unless publishable == false
  end
end
