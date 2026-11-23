# frozen_string_literal: true

module CaseManagement
  # Implementation of a CaseManagement that does not connect to a Case
  # Management System. Submitted requests go nowhere and no published requests
  # are imported, so the app can run without access to a real system.
  class Dummy
    SubmittedRequest = Struct.new(:reference)

    def self.configure!(_params)
      Rails.logger.warn(
        'Using the dummy case management. FOI requests will not be delivered.'
      )
    end

    def name
      self.class.name
    end

    def submit_foi_request!(**)
      SubmittedRequest.new("DUMMY-#{SecureRandom.hex(4).upcase}")
    end

    def published_requests(_query_params)
      []
    end

    def generate_url(published_request)
      published_request.url
    end

    def to_partial_path
      name.underscore
    end
  end
end
