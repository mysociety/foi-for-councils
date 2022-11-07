# frozen_string_literal: true

module CaseManagement
  class Demo
    class SubmittedRequest
      def initialize(request)
        @request = request
      end

      def reference
        "DEMO-#{SecureRandom.hex(4)}"
      end

      protected

      attr_reader :request
    end
  end
end

