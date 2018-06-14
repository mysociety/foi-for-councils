# frozen_string_literal: true

##
# A cache of published FOI requests and responses from the disclosure log.
#
class PublishedRequest < ApplicationRecord
  before_save :update_cached_columns

  def self.create_or_update_from_api!(attrs)
    existing = find_by(reference: attrs[:ref])

    if existing
      existing.update_payload_if_changed!(attrs)
    else
      create!(payload: attrs)
    end
  end

  def update_payload_if_changed!(attrs)
    if Date.parse(payload['dateclosed']) < Date.parse(attrs[:dateclosed])
      update!(payload: attrs)
    else
      false
    end
  end

  private

  def update_cached_columns
    cache_reference
    cache_title
    cache_url
    construct_summary
    cache_keywords
  end

  def cache_reference
    self.reference = payload['ref']
  end

  def cache_title
    self.title = payload['subject']
  end

  def cache_url
    self.url = payload['url']
  end

  def construct_summary
    text = payload['requestbody']
    text += "\n"
    text += responses.reverse.join("\n")
    self.summary = text
  end

  def responses
    payload['history'].fetch('response', []).map do |response|
      response['responsebody']
    end
  end

  def cache_keywords
    self.keywords = payload['keywords']
  end
end
