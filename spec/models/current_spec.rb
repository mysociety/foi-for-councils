# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Current, type: :model do
  describe '.case_management' do
    subject { described_class.case_management }
    let(:case_management) { double }
    before { described_class.case_management = case_management }
    it { is_expected.to eq(case_management) }
  end
end
