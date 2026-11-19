# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Making a request', type: :system do
  before do
    create(:curated_link, title: 'Housing budget 2018',
                          url: 'https://www.hackney.gov.uk/budget',
                          keywords: 'housing, budget')
  end

  it 'sends a request after showing suggestions' do
    visit '/foi'
    click_link 'Start your request'

    fill_in 'foi_request_body', with: 'What is the housing budget for 2018?'
    click_button 'Next: Contact details'
    expect(page).to have_link('Housing budget 2018')

    click_link 'Continue with request'
    fill_in 'contact_full_name', with: 'James T. Kirk'
    fill_in 'contact_email', with: 'kirk@example.com'
    click_button 'Check your request'
    expect(page).to have_text('What is the housing budget for 2018?')

    click_button 'Send now'
    expect(page).to have_title('Your request has been sent')
  end
end
