# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Admin curated links', type: :system, js: true do
  let!(:curated_link) do
    create(:curated_link, title: 'Housing budget 2018',
                          keywords: 'housing, budget')
  end

  before { sign_in_as_admin }

  it 'edits keywords with the keyword picker' do
    visit edit_admin_curated_link_path(curated_link)

    within('.keyword-picker-fake-input') do
      expect(page).to have_text('housing')
      find('input').send_keys('rent', :enter)
    end
    click_button 'Save Curated Link'

    expect(page).to have_text('Curated Link successfully updated')
    expect(curated_link.reload.keywords).to include('housing', 'rent')
  end

  it 'previews the link while it is edited' do
    visit edit_admin_curated_link_path(curated_link)
    fill_in 'curated_link_title', with: 'Council housing budget'

    within('.curated-link-preview') do
      expect(page).to have_text('Council housing budget')
    end
  end

  it 'asks before it deletes a link' do
    visit admin_curated_links_path

    dismiss_confirm('Are you sure?') { click_button 'Delete' }
    expect(curated_link.reload.destroyed_at).to be_nil

    accept_confirm('Are you sure?') { click_button 'Delete' }
    expect(page).to have_text('Curated Link successfully destroyed')
  end

  it 'signs out' do
    visit '/admin'
    click_link 'Sign out'

    expect(page).to have_current_path('/foi')
  end
end
