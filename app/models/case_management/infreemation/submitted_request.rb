# frozen_string_literal: true

module CaseManagement
  class Infreemation
    # Adapter for the response value after submitting an FOI request to the
    # Infreemation CaseManagement.
    class SubmittedRequest
      def initialize(request)
        @request = request
      end

      def reference
        attributes[:ref]
      end

      protected

      attr_reader :request

      private

      def attributes
        request.attributes
      end
    end
  end
end
