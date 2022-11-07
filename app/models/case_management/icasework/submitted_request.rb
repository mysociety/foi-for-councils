# frozen_string_literal: true

module CaseManagement
  class Demo
    # Adapter for the response value after submitting an FOI request to the
    # iCasework CaseManagement.
    class SubmittedRequest
      def initialize(request)
        @request = request
      end

      def reference
        'TEST-123'
      end

      protected

      attr_reader :request
    end
  end
end
