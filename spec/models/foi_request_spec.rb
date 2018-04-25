# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FoiRequest, type: :model do
  let(:request) { build_stubbed(:foi_request) }

  describe 'assoications' do
    it 'belongs to a contact' do
      expect(request.build_contact).to be_a Contact
    end

    it 'belongs to a submission' do
      expect(request.build_submission).to be_a Submission
    end

    it 'removes Contact on destroy' do
      request = create(:foi_request)
      expect { request.destroy }.to change { Contact.count }.by(-1)
    end

    it 'removes Submission on destroy' do
      request = create(:unqueued_foi_request)
      expect { request.destroy }.to change { Submission.count }.by(-1)
    end
  end

  describe 'attributes' do
    it 'requires an body' do
      request.body = nil
      expect(request.valid?).to eq false
      expect(request.errors[:body]).to_not be_empty
    end
  end

  describe 'scopes' do
    let!(:pending) { create(:foi_request) }
    let!(:unqueued) { create(:unqueued_foi_request) }
    let!(:queued) { create(:queued_foi_request) }

    describe '.unqueued' do
      subject { FoiRequest.unqueued }
      it { is_expected.to match [pending, unqueued] }
    end

    describe '.queued' do
      subject { FoiRequest.queued }
      it { is_expected.to match [queued] }
    end
  end
end
