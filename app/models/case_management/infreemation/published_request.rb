# frozen_string_literal: true

module CaseManagement
  class Infreemation
    # Adapter for the published requests feed from the Infreemation Case
    # Management System.
    class PublishedRequest
      def initialize(request)
        @request = request
      end

      def reference
        attributes[:ref]
      end

      def title
        attributes[:title]
      end

      def url
        attributes[:url]
      end

      def summary
        text = attributes[:requestbody]
        text += "\n"
        text += responses.reverse.join("\n")
        Summary.new(text).clean
      end

      def keywords
        attributes[:keywords]
      end

      def published_at
        date = attributes[:datepublished]
        Date.parse(date) if date.present?
      end

      def api_created_at
        date = attributes[:datecreated]
        Date.parse(date)
      end

      def publishable?
        attributes[:datepublished].present?
      end

      def payload
        attributes
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
          payload: payload }
      end

      def ==(other)
        other.request == request
      end

      protected

      attr_reader :request

      private

      def responses
        attributes[:history].fetch(:response, []).pluck(:responsebody)
      end

      def attributes
        request.attributes
      end
    end
  end
end
