# frozen_string_literal: true

module CaseManagement
  class Icasework
    # Adapter for the published requests feed from the iCasework Case Management
    # System.
    class PublishedRequest
      def initialize(request)
        @request = request
      end

      def reference
        request.case_id
      end

      # Hash for ApplicationRecord#assign_attributes
      def to_h
        { reference: reference }
      end

      def ==(other)
        other.request == request
      end

      protected

      attr_reader :request
    end
  end
end
