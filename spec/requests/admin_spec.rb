# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'admin namespace', type: :request do
  def sign_in
    get '/auth/google/callback'
  end

  describe 'signing in' do
    it 'redirects to the sign in page when signed out' do
      get '/admin'
      expect(response).to redirect_to('/auth/sign_in')
    end

    it 'renders the sign in page' do
      get '/auth/sign_in'
      expect(response.body).to include('Sign in')
    end

    it 'renders the unauthorised page for invalid credentials' do
      get '/auth/failure', params: { message: 'invalid_credentials' }
      expect(response).to have_http_status(:unauthorized)
    end

    it 'redirects to the page asked for before signing in' do
      get '/admin/curated_links'
      sign_in
      expect(response).to redirect_to('/admin/curated_links')
    end

    it 'redirects to the dashboard when a form post asked for sign in' do
      post '/admin/performance', params: { performance: { percentage: 90 } }
      sign_in
      expect(response).to redirect_to('/admin')
    end

    it 'signs out' do
      sign_in
      delete '/auth/sign_out'
      get '/admin'
      expect(response).to redirect_to('/auth/sign_in')
    end
  end

  context 'when signed in' do
    before { sign_in }

    it 'renders the dashboard' do
      get '/admin'
      expect(response.body).to include('Curated Links')
    end

    describe 'curated links' do
      let(:params) do
        { curated_link: { title: 'Budget', url: 'https://example.com' } }
      end

      let!(:curated_link) { create(:curated_link, title: 'Housing') }

      it 'renders the list' do
        get '/admin/curated_links'
        expect(response.body).to include('Housing')
      end

      it 'renders the new form' do
        get '/admin/curated_links/new'
        expect(response.body).to include('Add a new Curated Link')
      end

      it 'creates a curated link' do
        expect { post '/admin/curated_links', params: params }.
          to change(CuratedLink, :count).by(1)

        follow_redirect!
        expect(response.body).to include('Curated Link successfully created')
      end

      it 'renders errors for an invalid curated link' do
        post '/admin/curated_links', params: { curated_link: { title: '' } }
        expect(response.body).to include("can't be blank")
      end

      it 'renders the edit form' do
        get "/admin/curated_links/#{curated_link.id}/edit"
        expect(response.body).to include('Edit this Curated Link')
      end

      it 'updates a curated link' do
        patch "/admin/curated_links/#{curated_link.id}", params: params
        expect(curated_link.reload.title).to eq('Budget')
      end

      it 'renders errors when updating to an invalid curated link' do
        patch "/admin/curated_links/#{curated_link.id}",
              params: { curated_link: { title: '' } }
        expect(response.body).to include("can't be blank")
      end

      it 'destroys a curated link' do
        delete "/admin/curated_links/#{curated_link.id}"
        expect(curated_link.reload.destroyed_at).to be_present
      end

      it 'exports resources as CSV' do
        get '/admin/curated_links/export.csv'
        expect(response.media_type).to eq('text/csv')
        expect(response.body).to include('Housing')
      end
    end

    describe 'performance' do
      it 'renders the current performance' do
        create(:performance, percentage: 87)
        get '/admin/performance'
        expect(response.body).to include('87%')
      end

      it 'renders the new form' do
        get '/admin/performance/new'
        expect(response.body).to include('New performance percentage')
      end

      it 'creates a performance' do
        post '/admin/performance', params: { performance: { percentage: 90 } }
        expect(Performance.current_percentage).to eq(90)
      end

      it 'renders errors for an invalid performance' do
        post '/admin/performance', params: { performance: { percentage: 101 } }
        expect(response.body).to include('must be between 0 and 100')
      end
    end

    describe 'help' do
      before { CaseManagement.current = CaseManagement::Icasework.new }
      after { CaseManagement.current = nil }

      it 'renders the help for the current case management' do
        get '/admin/help'
        expect(response.body).to include('iCasework')
      end
    end
  end
end
