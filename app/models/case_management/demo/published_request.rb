# frozen_string_literal: true

module CaseManagement
  class Demo
    # Adapter for the published requests feed from the Demo Case
    # Management System.
    class PublishedRequest
      def initialize(request)
        @request = request
      end

      def reference
        request.reference
      end

      def title
        request.title
      end

      def url
        "https://www.example.com/request/#{reference}"
      end

      def summary
        request.summary
      end

      def keywords
        request.keywords
      end

      def published_at
        (3..1095).to_a.sample.days.ago.to_date
      end

      def api_created_at
        published_at
      end

      def publishable?
        true
      end

      def payload
        request.to_h
      end

      # Hash for ApplicationRecord#assign_attributes
      def to_h
        { reference: reference,
          title: title,
          url: url,
          summary: summary,
          keywords: keywords,
          published_at: published_at,
          api_created_at: api_created_at,
          publishable: publishable?,
          case_management: self.class.module_parent.name,
          payload: payload }
      end

      def ==(other)
        other.request == request
      end

      protected

      attr_reader :request
    end
  end
end
