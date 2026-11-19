# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'foi namespace', type: :request do
  describe 'GET /' do
    it 'redirects to foi namespace' do
      get '/'
      expect(response).to redirect_to('/foi')
    end
  end

  describe 'GET /foi/request' do
    it 'redirects to new request' do
      get '/foi/request'
      expect(response).to redirect_to('/foi/request/new')
    end
  end

  describe 'GET /foi/request/contact' do
    it 'redirects to new contact' do
      get '/foi/request/contact'
      expect(response).to redirect_to('/foi/request/contact/new')
    end
  end

  describe 'making a request' do
    let(:body) { 'What is the budget for housing in 2018?' }
    let(:contact) { { full_name: 'James T. Kirk', email: 'kirk@example.com' } }

    def make_request
      post '/foi/request', params: { foi_request: { body: body } }
    end

    def add_contact
      post '/foi/request/contact', params: { contact: contact }
    end

    def send_request
      post '/foi/request/send'
    end

    it 'renders the start page' do
      get '/foi'
      expect(response.body).to include('Make a request for information')
    end

    it 'renders the request form' do
      get '/foi/request/new'
      expect(response.body).to include('What do you want to know?')
    end

    it 'renders errors for a blank request' do
      post '/foi/request', params: { foi_request: { body: '' } }
      expect(response).to have_http_status(:unprocessable_entity)
      expect(response.body).to include("can't be blank")
    end

    it 'skips suggestions when nothing matches' do
      make_request
      expect(response).to redirect_to('/foi/request/suggestions')

      follow_redirect!
      expect(response).to redirect_to('/foi/request/contact/new')
    end

    context 'when a curated link matches the request' do
      let!(:curated_link) do
        create(:curated_link, title: 'Housing budget 2018',
                              url: 'https://www.hackney.gov.uk/budget',
                              keywords: 'housing, budget')
      end

      it 'renders the suggestions' do
        make_request
        follow_redirect!

        expect(response.body).to include('Housing budget 2018')
      end

      it 'counts a click and redirects to the suggestion' do
        make_request
        follow_redirect!
        suggestion = FoiSuggestion.last

        expect { get "/links/#{suggestion.id}" }.
          to change { suggestion.reload.clicks }.by(1)
        expect(response).to redirect_to(curated_link.url)
      end
    end

    it 'renders the request for editing' do
      make_request
      get '/foi/request/edit'
      expect(response.body).to include(body)
    end

    it 'updates the request' do
      make_request
      patch '/foi/request', params: { foi_request: { body: 'Updated' } }
      expect(FoiRequest.last.body).to eq('Updated')
    end

    it 'renders errors when updating to a blank request' do
      make_request
      patch '/foi/request', params: { foi_request: { body: '' } }
      expect(response.body).to include("can't be blank")
    end

    it 'renders the contact form' do
      make_request
      get '/foi/request/contact/new'
      expect(response.body).to include('How can we reply to you?')
    end

    it 'renders errors for an invalid contact' do
      make_request
      post '/foi/request/contact',
           params: { contact: contact.merge(email: 'invalid') }
      expect(response.body).to include('is invalid')
    end

    it 'renders the contact for editing' do
      make_request
      add_contact
      get '/foi/request/contact/edit'
      expect(response.body).to include('kirk@example.com')
    end

    it 'updates the contact' do
      make_request
      add_contact
      patch '/foi/request/contact',
            params: { contact: { email: 'spock@example.com' } }
      expect(Contact.last.email).to eq('spock@example.com')
    end

    it 'renders the request for preview' do
      make_request
      add_contact
      get '/foi/request/preview'
      expect(response.body).to include('Check your request before it is sent')
    end

    it 'queues the request and renders the sent page' do
      make_request
      add_contact

      expect { send_request }.
        to change { Submission.where(state: Submission::QUEUED).count }.by(1)

      follow_redirect!
      expect(response.body).to include('Thank you for your')
    end

    it 'renders the sent request as JSON' do
      make_request
      add_contact
      send_request

      get '/foi/request/sent.json'
      expect(response.parsed_body).to include('state' => Submission::QUEUED)
    end

    it 'shows the current performance on the sent page' do
      create(:performance, percentage: 87)
      make_request
      add_contact
      send_request

      get '/foi/request/sent'
      expect(response.body).to include('87%')
    end
  end
end
