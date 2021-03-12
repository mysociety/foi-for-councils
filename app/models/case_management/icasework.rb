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

    protected

    attr_reader :client
  end
end
