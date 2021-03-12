# frozen_string_literal: true

module CaseManagement
  # Implementation of a CaseManagement for the iCasework Case Management System.
  class Icasework
    def initialize(client: nil)
      @client = client || ::Icasework::Case
    end

    def submit_foi_request!(name:, email:, body:)
      request = client.create(
        'Type' => 'InformationRequest',
        'RequestMethod' => 'Online Form',
        'Customer.Name' => name,
        'Customer.Email' => email,
        'Details' => body
      )

      SubmittedRequest.new(request)
    end

    def published_requests(query_params)
      client_params = {
        'Type' => 'InformationRequest',
        'From' => query_params[:start_date],
        'Until' => query_params[:end_date]
      }

      client.
        where(client_params).
        map { |request| PublishedRequest.new(request) }
    end

    protected

    attr_reader :client
  end
end
