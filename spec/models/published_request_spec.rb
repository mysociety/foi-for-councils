# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PublishedRequest, type: :model do
  let(:published_request) { build_stubbed(:published_request) }

  describe 'associations' do
    it 'has many FOI suggestions' do
      expect(published_request.foi_suggestions.new).to be_a FoiSuggestion
    end

    it 'removes FOI suggestions on destroy' do
      published_request = create(:published_request_with_suggestions)
      expect { published_request.destroy }.to change(FoiSuggestion, :count).
        from(3).to(0)
    end
  end

  describe '.source' do
    subject { described_class.source(case_management) }

    let!(:fake) do
      FactoryBot.create(:published_request,
                        case_management: 'CaseManagement::Fake')
    end

    let!(:other) do
      FactoryBot.create(:published_request,
                        case_management: 'CaseManagement::Other')
    end

    let(:case_management) { double(name: 'CaseManagement::Fake') }

    it { is_expected.to match_array([fake]) }
  end

  describe '.create_update_or_destroy_from_api!' do
    subject { described_class.create_update_or_destroy_from_api!(request) }

    let(:request) { double(reference: 'FOI-1', to_h: {}) }

    let(:record) do
      double = instance_double(described_class.to_s)
      allow(double).to receive(:assign_attributes)
      allow(double).to receive(:save_or_destroy!)
      double
    end

    before do
      allow(described_class).
        to receive(:find_or_initialize_by).and_return(record)
    end

    it 'assigns the payload to the record' do
      expect(record).to receive(:assign_attributes).with(request.to_h)
      subject
    end

    it 'attempts to save or destroy the record' do
      expect(record).to receive(:save_or_destroy!)
      subject
    end

    it 'returns the record' do
      expect(subject).to eq(record)
    end
  end

  describe '#url' do
    subject { published_request.url }
    let(:published_request) { build(:published_request, url: url) }

    context 'when the url is set' do
      let(:url) { 'https://example.com' }
      it { is_expected.to eq('https://example.com') }
    end

    context 'when the url is nil' do
      let(:url) { nil }

      before do
        expect(CaseManagement).
          to receive(:generate_url).with(published_request).
          and_return('https://example.com')
      end

      it { is_expected.to eq('https://example.com') }
    end
  end

  describe '#save_or_destroy!' do
    let(:published_request) { build(:published_request) }

    context 'with a new record' do
      context 'when marked as publishable' do
        before { published_request.publishable = true }

        it 'persists the record' do
          expect { published_request.save_or_destroy! }.
            to change { described_class.count }.by(1)
        end
      end

      context 'when not marked as publishable' do
        before { published_request.publishable = false }

        it 'does not persist the record' do
          expect { published_request.save_or_destroy! }.
            not_to(change { described_class.count })
        end
      end
    end

    context 'with a persisted record' do
      before { published_request.save! }

      context 'when marked as publishable' do
        before do
          published_request.title = 'New title'
          published_request.publishable = true
        end

        it 'updates the record when datepublished is not blank' do
          published_request.save_or_destroy!
          expect(published_request.saved_changes?).to eq(true)
        end
      end

      context 'when not marked as publishable' do
        before { published_request.publishable = false }

        it 'destroys the record' do
          expect { published_request.save_or_destroy! }.
            to change { described_class.count }.by(-1)
        end
      end
    end
  end
end
