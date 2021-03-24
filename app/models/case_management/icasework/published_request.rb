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

      # There's no attribute that just returns the non-prefixed label, so we
      # have to strip it ourselves.
      def title
        case_details[:case_label].gsub('IR - ', '')
      end

      # We can't store this since the access token is only valid for an hour.
      # Instead we must generate it in PublishedRequest at runtime.
      def url
        nil
      end

      # TODO: Extract contents of documents
      def summary
        case_attributes[:details]
      end

      def keywords
        request.classifications.flat_map { |c| [c.group, c.title] }.join(', ')
      end

      def published_at
        publish_in_the_disclosure_log_date ||
          case_stage_stage_1_date_completed ||
          api_created_at
      end

      def publishable?
        case_attributes[:publish_in_the_disclosure_log] == 'Yes'
      end

      def api_created_at
        Date.parse(case_status_receipt[:time_created])
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

      private

      def publish_in_the_disclosure_log_date
        try_parse_date(
          request[:case_details_information_request] \
          [:publish_in_the_disclosure_log_date]
        )
      end

      def case_stage_stage_1_date_completed
        try_parse_date(
          request[:case_stage_stage].pluck(:date_completed).compact.min
        )
      end

      def case_details
        request[:case_details]
      end

      def case_status_receipt
        request[:case_status_receipt]
      end

      def case_attributes
        request[:attributes]
      end

      def documents
        request[:documents]
      end

      def try_parse_date(date)
        Date.parse(date) if date
      end
    end
  end
end
