# frozen_string_literal: true

module CaseManagement
  # Implementation of a CaseManagement for the iCasework Case Management System.
  class Icasework
    def self.configure!(params)
      ::Icasework.env = Rails.env

      params.each do |key, value|
        ::Icasework.public_send("#{key}=", value)
      end
    end

    def initialize(client: nil)
      @client = client || ::Icasework::Case
    end

    def name
      self.class.name
    end

    def submit_foi_request!(name:, email:, body:)
      request = client.create(type: 'InformationRequest',
                              request_method: 'Online Form',
                              customer: { name: name, email: email },
                              details: body)

      SubmittedRequest.new(request)
    end

    protected

    attr_reader :client
  end
end
