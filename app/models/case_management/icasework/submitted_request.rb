# frozen_string_literal: true

module CaseManagement
  class Icasework
    # Adapter for the response value after submitting an FOI request to the
    # iCasework CaseManagement.
    class SubmittedRequest
      def initialize(request)
        @request = request
      end

      def reference
        request.case_id
      end

      protected

      attr_reader :request
    end
  end
end
