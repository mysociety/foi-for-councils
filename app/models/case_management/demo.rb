# frozen_string_literal: true

module CaseManagement
  # Implementation of a CaseManagement for development and demos
  class Demo
    def self.configure!(params)
      true
    end

    def initialize(client: nil)
      @client = nil
    end

    def name
      self.class.name
    end

    def submit_foi_request!(name:, email:, body:)
      SubmittedRequest.new(nil)
    end

    def published_requests(query_params)
      sample_data.
        map { |request| self.class::PublishedRequest.new(request) }
    end

    def generate_url(published_request)
      published_request.url
    end

    def to_partial_path
      name.underscore
    end

    private

    def sample_data
      [
        { reference: 'foo',
          title: 'Foo',
          summary: 'Foo 2 3 4',
          keywords: 'foo bar baz' }
      ].map { |h| OpenStruct.new(h) }
    end
  end
end
