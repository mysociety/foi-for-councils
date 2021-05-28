# frozen_string_literal: true

module CaseManagement
  # Implementation of a CaseManagement for the Infreemation Case Management
  # System.
  class Infreemation
    def self.configure!(params)
      ::Infreemation.logger = Rails.logger

      params.each do |key, value|
        ::Infreemation.public_send("#{key}=", value)
      end
    end

    def initialize(client: nil)
      @client = client || ::Infreemation::Request
    end

    def name
      self.class.name
    end

    def submit_foi_request!(name:, email:, body:)
      request = client.create!(
        rt: 'create',
        type: 'FOI',
        contacttype: 'email',
        requester: name,
        contact: email,
        body: body
      )

      SubmittedRequest.new(request)
    end

    def published_requests(query_params)
      client_params = {
        rt: 'published',
        startdate: query_params[:start_date],
        enddate: query_params[:end_date]
      }

      client.
        where(client_params).
        map { |request| self.class::PublishedRequest.new(request) }
    end

    def generate_url(published_request)
      published_request.url
    end

    def to_partial_path
      name.underscore
    end

    protected

    attr_reader :client
  end
end
