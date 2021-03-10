# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CurrentCaseManagement do
  controller(ActionController::Base) do
    include CurrentCaseManagement

    def index
      head :ok
    end
  end

  before do
    routes.draw do
      get 'index' => 'anonymous#index'
    end
  end

  describe 'GET #index' do
    subject { get :index }

    before { Current.reset }
    after { Current.reset }

    it 'sets the current case management system' do
      expect { subject }.
        to change { Current.case_management }.
        from(nil).
        to(CaseManagement::Infreemation.new)
    end
  end
end
