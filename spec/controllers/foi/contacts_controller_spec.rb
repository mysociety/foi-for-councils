# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Foi::ContactsController, type: :controller do
  let(:foi_request) { build_stubbed(:foi_request) }
  let(:contact) { build_stubbed(:contact) }
  let(:valid_params) { { full_name: 'Spock', email: 'spock@localhost' } }
  let(:invalid_params) { { invalid: true } }

  before do
    allow(FoiRequest).to receive(:find).with('1').and_return(foi_request)
  end

  describe 'GET #show' do
    subject { get :show, params: { request_id: '1' } }

    it 'returns http success' do
      is_expected.to have_http_status(200)
    end

    it 'renders show view' do
      is_expected.to render_template(:show)
    end

    it 'assigns foi_request' do
      subject
      expect(assigns(:foi_request)).to eq foi_request
    end
  end

  describe 'PUT #update' do
    shared_examples 'valid parameters' do
      subject { put :update, params: { request_id: '1', contact: valid_params } }
      before { allow(contact).to receive(:update).and_return(true) }

      it 'receives valid attributes' do
        expect(contact).to receive(:update)
          .with(ActionController::Parameters.new(valid_params).permit!)
        subject
      end

      it 'redirects to foi_request' do
        is_expected.to redirect_to(foi_request_path(foi_request))
      end
    end

    shared_examples 'invalid parameters' do
      subject { put :update, params: { request_id: '1', contact: invalid_params } }
      before { allow(contact).to receive(:update).and_return(false) }

      it 'returns http success' do
        is_expected.to have_http_status(200)
      end

      it 'renders edit view' do
        is_expected.to render_template(:show)
      end

      it 'assigns contact' do
        subject
        expect(assigns(:contact)).to eq contact
      end
    end

    context 'contact exist' do
      before { allow(foi_request).to receive(:contact).and_return(contact) }
      it_behaves_like 'valid parameters'
      it_behaves_like 'invalid parameters'
    end

    context 'contact does not exist' do
      before do
        allow(foi_request).to receive(:contact).and_return(nil)
        allow(foi_request).to receive(:build_contact).and_return(contact)
      end

      it_behaves_like 'valid parameters'
      it_behaves_like 'invalid parameters'
    end
  end
end
