# frozen_string_literal: true

module SignInHelpers
  def sign_in_as_admin
    visit '/auth/sign_in'
    click_button 'Sign in'
    expect(page).to have_text('Logged in as')
  end
end

RSpec.configure do |config|
  config.include SignInHelpers, type: :system

  signs_in = ->(type) { %i[system request].include?(type) }

  config.around(:each, type: signs_in) do |example|
    OmniAuth.config.test_mode = true
    OmniAuth.config.mock_auth[:google] = OmniAuth::AuthHash.new(
      provider: 'google',
      uid: '123',
      info: { email: 'kirk@example.com', name: 'James T. Kirk' },
      credentials: { expires_at: 1.hour.from_now.to_i }
    )
    example.run
  ensure
    OmniAuth.config.mock_auth.delete(:google)
    OmniAuth.config.test_mode = false
  end
end
