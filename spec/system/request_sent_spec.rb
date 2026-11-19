# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Sent request page', type: :system, js: true do
  def send_request
    visit '/foi/request/new'
    fill_in 'foi_request_body', with: 'What is the housing budget for 2018?'
    click_button 'Next: Contact details'
    fill_in 'contact_full_name', with: 'James T. Kirk'
    fill_in 'contact_email', with: 'kirk@example.com'
    click_button 'Check your request'
    click_button 'Send now'
  end

  it 'shows the reference once the request is delivered' do
    send_request
    expect(page).to have_text('Sending your request')

    Submission.last.update!(reference: 'FOI-123')
    expect(page).to have_text('FOI-123', wait: 10)
  end

  it 'falls back to the generic message when delivery is slow' do
    send_request
    expect(page).to have_text('We will email a reference number', wait: 10)
  end

  it 'falls back to the generic message when the status check fails' do
    send_request
    expect(page).to have_text('Sending your request')
    page.execute_script('window.fetch = () => Promise.reject(new TypeError())')
    expect(page).to have_text('We will email a reference number', wait: 3)
  end

  it 'stops checking once the visitor leaves the page' do
    send_request
    expect(page).to have_text('Sending your request')
    page.execute_script(<<~JS)
      window.checks = 0
      const fetch = window.fetch
      window.fetch = (url, options) => {
        if (!String(url).endsWith('.json')) return fetch(url, options)
        window.checks++
        return new Promise(resolve =>
          setTimeout(() => resolve(new Response('{}')), 1000))
      }
    JS
    Timeout.timeout(3) do
      sleep 0.1 until page.evaluate_script('window.checks') == 1
    end

    page.execute_script("Turbo.visit('/')")
    expect(page).to have_no_text('Sending your request')
    sleep 3
    expect(page.evaluate_script('window.checks')).to eq(1)
  end

  it 'prints the page' do
    send_request
    expect(page).to have_text('Sending your request')
    page.execute_script('window.print = () => { window.printed = true }')
    click_button 'Print this page'
    expect(page.evaluate_script('window.printed')).to be(true)
  end
end
