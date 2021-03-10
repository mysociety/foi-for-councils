# frozen_string_literal: true

require 'rails_helper'

require 'controllers/concerns/current_case_management'

RSpec.describe ApplicationController, type: :controller do
  it_behaves_like 'CurrentCaseManagement', :index do
    controller do
      def index
        head :ok
      end
    end
  end
end
