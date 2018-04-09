# frozen_string_literal: true

module FindableFoiRequest
  extend ActiveSupport::Concern

  included do
    before_action :find_foi_request

    private

    def find_foi_request
      @foi_request = FoiRequest.find(params.require(:request_id))
    end
  end
end
