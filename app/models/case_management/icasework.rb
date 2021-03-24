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

    def published_requests(query_params)
      client_params = {
        type: 'InformationRequest',
        from: query_params[:start_date],
        until: query_params[:end_date]
      }

      client.
        where(client_params).
        map { |request| self.class::PublishedRequest.new(request) }
    end

    def generate_url(published_request)
      # TODO: Add PublishedRequest#metadata column and extract this filtering to
      # Icasework::PublishedRequest#metadata so that we don't pollute the
      # "original" payload with extra attributes we've added for convenience.
      documents = published_request.payload.deep_symbolize_keys[:documents]

      responses = documents.select do |document|
        document[:name] =~ /\AResponse\s\((\w+\s?)+\)\z/ &&
          document[:type] == 'application/pdf'
      end

      case_id = published_request.reference
      document_id = responses.first[:id]

      ::Icasework::Document.find(
        case_id: case_id, document_id: document_id, self_service: 'True'
      ).url
    end

    protected

    attr_reader :client
  end
end
