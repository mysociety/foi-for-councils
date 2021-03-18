# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DisclosureLog, type: :service do
  describe 'initialisation' do
    before { travel_to Time.utc(2018, 6, 18, 11, 30) }

    it 'accepts a start_date' do
      subject = described_class.new(start_date: Date.new(2018, 2, 1))
      expect(subject.start_date).to eq Date.new(2018, 2, 1)
    end

    it 'defaults start_date to beginning of year' do
      expect(subject.start_date).to eq Date.new(2018, 1, 1)
    end

    it 'accepts an end_date' do
      subject = described_class.new(end_date: Date.new(2018, 2, 1))
      expect(subject.end_date).to eq Date.new(2018, 2, 1)
    end

    it 'defaults end_date to today' do
      expect(subject.end_date).to eq Date.new(2018, 6, 18)
    end
  end

  describe '#import!' do
    subject { described_class.new(case_management: case_management).import! }

    before do
      travel_to(Time.utc(2018, 6, 18, 11, 30))
    end

    let(:case_management) do
      double(published_requests: published_requests,
             name: 'CaseManagement::Fake')
    end

    let(:published_requests) do
      [double(reference: 'FOI-2',
              to_h: { reference: 'FOI-2',
                      case_management: 'CaseManagement::Fake',
                      publishable: true }),
       double(reference: 'FOI-4',
              to_h: { reference: 'FOI-4',
                      case_management: 'CaseManagement::Fake',
                      publishable: false })]
    end

    # This request is outside the default start_date of 1 year ago
    # It is not returned by the feed
    # It will stay persisted
    let!(:published_request1) do
      create(:published_request,
             reference: 'FOI-1',
             case_management: 'CaseManagement::Fake',
             published_at: Time.zone.parse('2010-01-01'),
             api_created_at: Time.zone.parse('2010-01-01'))
    end

    # This request is inside the window of results that we may expect
    # It is returned by the feed
    # It is publishable so it will stay persisted
    let!(:published_request2) do
      create(:published_request,
             reference: 'FOI-2',
             case_management: 'CaseManagement::Fake',
             published_at: Time.zone.parse('2018-06-17'),
             api_created_at: Time.zone.parse('2018-06-17'))
    end

    # This request is inside the window of results that we may expect
    # It is not returned by the feed
    # It will be deleted
    let!(:published_request3) do
      create(:published_request,
             reference: 'FOI-3',
             case_management: 'CaseManagement::Fake',
             published_at: Time.zone.parse('2018-06-17'),
             api_created_at: Time.zone.parse('2018-06-17'))
    end

    # This request is inside the window of results that we may expect
    # It is returned by the feed
    # It is not publishable so will be deleted
    let!(:published_request4) do
      create(:published_request,
             reference: 'FOI-4',
             case_management: 'CaseManagement::Fake',
             published_at: Time.zone.parse('2018-06-17'),
             api_created_at: Time.zone.parse('2018-06-17'))
    end

    # This request is inside the window of results that we may expect
    # It is from a different case management
    # It will stay persisted
    let!(:published_request5) do
      create(:published_request,
             reference: 'FOI-5',
             case_management: 'CaseManagement::DifferentSystem',
             published_at: Time.zone.parse('2018-06-17'),
             api_created_at: Time.zone.parse('2018-06-17'))
    end

    it 'keeps requests that are older than the start date param of the import' do
      subject
      expect(published_request1.reload).to be_persisted
    end

    it 'keeps publishable requests inside the import window that are returned by the feed' do
      subject
      expect(published_request2.reload).to be_persisted
    end

    it 'keeps requests from other case management systems' do
      subject
      expect(published_request5.reload).to be_persisted
    end

    it 'destroys requests inside the import window that are not returned by the feed' do
      subject
      expect { published_request3.reload }.
        to raise_error(ActiveRecord::RecordNotFound)
    end

    it 'destroys requests inside the import window that are not publishable' do
      subject
      expect { published_request4.reload }.
        to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe '#import' do
    subject { described_class.new(case_management: case_management).import }

    let(:published_requests) do
      [double(reference: 'FOI-1'), double(reference: 'FOI-2')]
    end

    let(:case_management) { double(published_requests: published_requests) }

    context 'successful response' do
      it 'creates or update published requests' do
        published_requests.each do |request|
          expect(PublishedRequest).
            to receive(:create_update_or_destroy_from_api!).
            with(request)
        end

        subject
      end
    end

    context 'unsuccessful response' do
      before do
        allow(case_management).
          to receive(:published_requests).
          and_raise(StandardError)
      end

      it 'does not capture the exception' do
        expect { subject.import }.to raise_error(StandardError)
      end
    end
  end
end
