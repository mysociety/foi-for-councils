# frozen_string_literal: true

require 'sidekiq/testing'

Sidekiq.logger.level = Logger::WARN

RSpec.configure do |config|
  config.before(:each) do
    Sidekiq::Worker.clear_all
  end
end
