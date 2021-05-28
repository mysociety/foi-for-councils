# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'admin/help/index', type: :view do
  let(:case_management) do
    double(to_partial_path: 'case_management/icasework')
  end

  it 'renders the partial for the assigned case management' do
    assign :case_management, case_management
    render
    expect(rendered).to match(/icasework/i)
  end
end
