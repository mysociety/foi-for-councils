# frozen_string_literal: true

require_relative 'redis.rb'

redis_connection = proc { Redis.current }

unless Rails.env.production?
  Sidekiq::Scheduler.rufus_scheduler_options = { max_work_threads: 5 }
end

Sidekiq.configure_server do |config|
  # https://github.com/moove-it/sidekiq-scheduler#notes-about-connection-pooling
  size = Rails.env.production? ? 58 : 15
  config.redis = ConnectionPool.new(size: size, &redis_connection)
end

Sidekiq.configure_client do |config|
  size = Rails.env.production? ? 5 : 1
  config.redis = ConnectionPool.new(size: size, &redis_connection)
end
