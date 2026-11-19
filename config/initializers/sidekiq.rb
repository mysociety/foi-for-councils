# frozen_string_literal: true

require 'mysociety/redis'

Sidekiq.configure_server do |config|
  config.redis = MySociety::Redis.options
end

Sidekiq.configure_client do |config|
  config.redis = MySociety::Redis.options
end
