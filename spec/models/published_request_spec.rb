# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PublishedRequest, type: :model do
  describe '.create_or_update_from_api!' do
    subject { described_class.create_or_update_from_api!(attributes) }

    context 'when a record with the ref does not exist' do
      let(:attributes) { attributes_for(:published_request)[:payload] }

      it 'persists the record' do
        expect { subject }.to change { described_class.count }.by(1)
      end
    end

    context 'when a record with the ref exists and attributes have changed' do
      let(:attributes) { attributes_for(:published_request)[:payload] }

      let!(:published_request) do
        old_attrs =
          attributes.merge(dateclosed: '1918-04-22', keywords: 'old')

        create(:published_request, payload: old_attrs)
      end

      it 'does not create a new record' do
        expect { subject }.not_to(change { described_class.count })
      end

      it 'updates the payload' do
        subject
        expect(published_request.reload.payload['keywords']).
          to eq('Business, business rates')
      end
    end
  end

  describe '#update_payload_if_chanegd!' do
    subject { published_request.update_payload_if_changed!(attributes) }

    let!(:published_request) { create(:published_request) }

    context 'when the dateclosed is ahead of the cached record' do
      let(:attributes) do
        attributes_for(:published_request)[:payload].
          merge(dateclosed: Time.zone.tomorrow.to_s)
      end

      it 'updates with the new attributes' do
        subject
        expect(published_request.payload['dateclosed']).
          to eq(Time.zone.tomorrow.to_s)
      end

      it { is_expected.to eq(true) }
    end

    context 'when the dateclosed is the same as the cached record' do
      let(:attributes) do
        # Even though the attributes have changed, we shouldn't try to update
        # because we're relying on them to provide a correct dateclosed so that
        # we reduce DB writes.
        attributes_for(:published_request)[:payload].merge(keywords: 'new')
      end

      before do
        # Clear changes information from initial save
        # See http://api.rubyonrails.org/classes/ActiveModel/Dirty.html#
        # method-i-clear_changes_information
        published_request.clear_changes_information
      end

      it 'does not update the record' do
        subject
        expect(published_request.previous_changes).to be_empty
      end

      it { is_expected.to eq(false) }
    end
  end

  describe '#save' do
    let(:published_request) { build(:published_request) }

    before do
      published_request.save!
      published_request.reload
    end

    it 'creates a cache of the reference' do
      expect(published_request.reference).to eq('FOI-1')
    end

    it 'creates a cache of the keywords' do
      expect(published_request.keywords).to eq('Business, business rates')
    end

    it 'creates a cache of the url' do
      url = 'http://foi.infreemation.co.uk/redirect/hackney?id=1'
      expect(published_request.url).to eq(url)
    end

    it 'creates a cache of the subject as title' do
      expect(published_request.title).to eq('Business Rates')
    end

    it 'constructs a cache of the summary' do
      # Munge all responses in to one field for searching
      expected = <<-TEXT.strip_heredoc.chomp
      Initial FOI Request
      Dear Redacted
      Automated acknowledgement.
      Dear Redacted
      FOI Response
      Thank you for your help
      TEXT
      expect(published_request.summary).to eq(expected)
    end
  end
end
