# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CaseManagement::Dummy, type: :model do
  let(:case_management) { described_class.new }

  describe '.configure!' do
    it 'needs no client params' do
      expect { described_class.configure!(nil) }.not_to raise_error
    end

    it 'warns that requests will not be delivered' do
      expect(Rails.logger).to receive(:warn).with(/not be delivered/)
      described_class.configure!(nil)
    end
  end

  describe '#submit_foi_request!' do
    subject do
      case_management.submit_foi_request!(name: 'John Doe',
                                          email: 'john@example.com',
                                          body: 'Some information')
    end

    it 'returns a dummy reference' do
      expect(subject.reference).to match(/\ADUMMY-\h{8}\z/)
    end
  end

  describe '#published_requests' do
    subject { case_management.published_requests(start_date: Time.zone.today) }
    it { is_expected.to eq([]) }
  end
end
