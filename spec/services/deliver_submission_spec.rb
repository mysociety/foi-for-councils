# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DeliverSubmission, type: :service do
  let(:contact) { build(:contact, full_name: 'Worf', email: 'worf@ufp') }
  let(:foi_request) do
    build(:foi_request, :queued, contact: contact, body: 'A FOI request')
  end
  let(:submission) { foi_request.submission }
  let(:submitted_request) { double(reference: '001') }
  let(:case_management) { double(submit_foi_request!: submitted_request) }

  describe 'initialization' do
    it 'defaults case_management to the current case_management' do
      case_management = double

      Current.set(case_management: case_management) do
        expect(described_class.new(double).send(:case_management)).
          to eq(case_management)
      end
    end
  end

  subject(:service) do
    described_class.new(submission, case_management: case_management)
  end

  describe '#call' do
    context 'successful response' do
      before do
        expect(case_management).to receive(:submit_foi_request!).
          with(name: 'Worf', email: 'worf@ufp', body: 'A FOI request')
      end

      it 'changes the state to delivered' do
        expect { service.call }.to change(submission, :state).
          to(Submission::DELIVERED)
      end

      it 'sets the reference' do
        expect { service.call }.to change(submission, :reference).
          from(nil).to('001')
      end

      it 'persists the change' do
        expect { service.call }.to change(submission, :persisted?).
          to(true)
      end
    end

    context 'unsuccessful response' do
      before do
        allow(case_management).
          to receive(:submit_foi_request!).
          and_raise(StandardError)
      end

      it 'does not capture the exception' do
        expect { service.call }.to raise_error(StandardError)
      end
    end
  end
end
