# frozen_string_literal: true

RSpec.shared_examples 'CurrentCaseManagement' do |action|
  subject { get action }

  before { Current.reset }
  after { Current.reset }

  it 'sets the current case management system' do
    expect { subject }.
      to change { Current.case_management }.
      from(nil).
      to(CaseManagement::Infreemation.new)
  end
end
