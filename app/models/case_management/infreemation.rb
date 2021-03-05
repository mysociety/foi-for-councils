# frozen_string_literal: true

module CaseManagement
  # Implementation of a CaseManagement for the Infreemation Case Management
  # System.
  class Infreemation
    def initialize(client: nil)
      @client = client || ::Infreemation::Request
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

    protected

    attr_reader :client
  end
end
