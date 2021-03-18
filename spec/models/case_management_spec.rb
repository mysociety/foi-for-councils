# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CaseManagement, type: :model do
  before { described_class.current = nil }
  after { described_class.current = nil }

  describe '.constantize' do
    subject { described_class.constantize(name) }

    context 'when the name is correctly namespaced' do
      let(:name) { 'CaseManagement::Infreemation' }
      it { is_expected.to eq(CaseManagement::Infreemation) }
    end

    context 'when only the class name is given' do
      let(:name) { 'Infreemation' }
      it { is_expected.to eq(CaseManagement::Infreemation) }
    end
  end

  describe '.current' do
    subject { described_class.current }

    context 'when configured' do
      before do
        allow(described_class).
          to receive(:config).and_return(adapter: 'Infreemation')
      end

      it { is_expected.to be_a(CaseManagement::Infreemation) }
    end

    context 'when configured with a case management that does not exist' do
      before do
        allow(described_class).
          to receive(:config).and_return(adapter: 'Unknown')
      end

      specify { expect { subject }.to raise_error(NameError) }
    end

    context 'when not configured' do
      specify { expect { subject }.to raise_error(NameError) }
    end
  end

  describe '.current=' do
    subject { described_class.current = case_management }
    let(:case_management) { double }

    it 'sets the current case management' do
      subject
      expect(described_class.current).to eq(case_management)
    end
  end

  describe '.config' do
    subject { described_class.config }

    let(:config) do
      { adapter: 'Infreemation',
        client_params: { url: 'a', username: 'b', api_key: 'c' } }
    end

    before do
      allow(Rails.application).
        to receive(:config_for).with(:case_management).and_return(config)
    end

    it 'configures the adapter' do
      expect(described_class::Infreemation).
        to receive(:configure!).with(config[:client_params])

      subject
    end

    it { is_expected.to eq(config) }
  end
end
