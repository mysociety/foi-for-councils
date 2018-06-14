# frozen_string_literal: true

##
# Creates a local cache of requests published in the disclosure log
#
class DisclosureLog
  attr_reader :query_params

  def initialize(*)
    @query_params =
      { rt: 'published', startdate: '2018-01-01', enddate: Time.zone.today }
  end

  def import
    Infreemation::Request.where(query_params).map do |request|
      PublishedRequest.create_or_update_from_api!(request.attributes)
    end
  end
end
