# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DisclosureLog, type: :service do
  let(:requests) do
    [Infreemation::Request.new(ref: 'FOI-1'),
     Infreemation::Request.new(ref: 'FOI-2')]
  end

  describe '#import' do
    context 'successful response' do
      before do
        allow(Infreemation::Request).to receive(:where).and_return(requests)
      end

      it 'changes the state to delivered' do
        requests.each do |request|
          expect(PublishedRequest).
            to receive(:create_or_update_from_api!).with(request.attributes)
        end

        subject.import
      end
    end

    context 'unsuccessful response' do
      before do
        allow(Infreemation::Request).to receive(:where).
          and_raise(Infreemation::GenericError)
      end

      it 'does not capture the exception' do
        expect { subject.import }.to raise_error(Infreemation::GenericError)
      end
    end
  end
end
