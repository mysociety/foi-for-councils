# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Foi::RequestsController, type: :controller do
  let(:foi_request) { build_stubbed(:foi_request) }
  let(:valid_params) { { body: 'A request body' } }
  let(:invalid_params) { { invalid: true } }

  describe 'GET #index' do
    subject { get :index }

    it 'returns http success' do
      is_expected.to have_http_status(200)
    end

    it 'renders index view' do
      is_expected.to render_template(:index)
    end
  end

  describe 'GET #new' do
    subject { get :new }
    before { allow(FoiRequest).to receive(:new).and_return(foi_request) }

    it 'returns http success' do
      is_expected.to have_http_status(200)
    end

    it 'renders new view' do
      is_expected.to render_template(:new)
    end

    it 'assigns foi_request' do
      subject
      expect(assigns(:foi_request)).to eq foi_request
    end
  end

  describe 'POST #create' do
    context 'valid parameters' do
      subject { post :create, params: { foi_request: valid_params } }

      before do
        allow(FoiRequest).to receive(:new).and_return(foi_request)
        allow(foi_request).to receive(:update)
          .and_return(true)
      end

      it 'receives valid attributes' do
        expect(foi_request).to receive(:update)
          .with(ActionController::Parameters.new(valid_params).permit!)
        subject
      end

      it 'redirects to suggestions' do
        is_expected.to redirect_to(foi_request_suggestions_path(foi_request))
      end
    end

    context 'invalid parameters' do
      subject { post :create, params: { foi_request: invalid_params } }

      before do
        allow(FoiRequest).to receive(:new).and_return(foi_request)
        allow(foi_request).to receive(:update).and_return(false)
      end

      it 'returns http success' do
        is_expected.to have_http_status(200)
      end

      it 'renders new view' do
        is_expected.to render_template(:new)
      end

      it 'assigns foi_request' do
        subject
        expect(assigns(:foi_request)).to eq foi_request
      end
    end
  end

  describe 'GET #show' do
    subject { get :show, params: { id: '1' } }

    before do
      allow(FoiRequest).to receive(:find).with('1').and_return(foi_request)
    end

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

  describe 'GET #edit' do
    subject { get :edit, params: { id: '1' } }

    before do
      allow(FoiRequest).to receive(:find).with('1').and_return(foi_request)
    end

    it 'returns http success' do
      expect(response).to have_http_status(200)
    end

    it 'renders edit view' do
      is_expected.to render_template(:edit)
    end

    it 'assigns foi_request' do
      subject
      expect(assigns(:foi_request)).to eq foi_request
    end
  end

  describe 'PUT #update' do
    before do
      allow(FoiRequest).to receive(:find).with('1').and_return(foi_request)
    end

    context 'valid parameters' do
      subject { put :update, params: { id: '1', foi_request: valid_params } }
      before { allow(foi_request).to receive(:update).and_return(true) }

      it 'receives valid attributes' do
        expect(foi_request).to receive(:update)
          .with(ActionController::Parameters.new(valid_params).permit!)
        subject
      end

      it 'redirects to suggestions' do
        is_expected.to redirect_to(foi_request_suggestions_path(foi_request))
      end
    end

    context 'invalid parameters' do
      subject { put :update, params: { id: '1', foi_request: invalid_params } }
      before { allow(foi_request).to receive(:update).and_return(false) }

      it 'returns http success' do
        is_expected.to have_http_status(200)
      end

      it 'renders edit view' do
        is_expected.to render_template(:edit)
      end

      it 'assigns foi_request' do
        subject
        expect(assigns(:foi_request)).to eq foi_request
      end
    end
  end
end
