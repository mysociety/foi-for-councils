# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Admin::HelpController, type: :controller do
  let(:session) do
    { current_user: 123, authenticated_until: 1.hour.from_now.to_i }
  end

  before do
    allow(User).to receive(:find_by).with(uid: 123).and_return(build(:user))
  end

  describe 'GET #index' do
    subject { get :index, session: session }

    before { CaseManagement.current = case_management }
    after { CaseManagement.current = nil }

    let(:case_management) do
      double(to_partial_path: 'case_management/icasework')
    end

    it 'returns http success' do
      is_expected.to have_http_status(200)
    end
  end
end
