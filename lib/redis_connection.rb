# frozen_string_literal: true

##
# Module to parse Redis ENV variables into usable configuration for Sidekiq.
#
# Example config:
#
# Required:
# - ENV['REDIS_URL'] => 'redis://:[password]@[hostname]:[port]/[db]'
# or
# - ENV['REDIS_URL'] => 'redis://[master_name]/[db]'
#
# - ENV['REDIS_SENTINELS'] => '0.0.0.0:26380,0.0.0.0:26381,...'
# or
# - ENV['REDIS_SENTINELS'] => '[::1]:26380,[::1]:26381,...'
#
module RedisConnection
  def self.configuration
    { url: ENV['REDIS_URL'], password: ENV['REDIS_PASSWORD'] }.
      merge(sentinel_configuration)
  end

  def self.sentinel_configuration
    return {} unless ENV['REDIS_SENTINELS']

    sentinels = ENV['REDIS_SENTINELS'].split(',').map do |ip_and_port|
      ip, port = ip_and_port.split(/:(\d+)$/)
      ip = Regexp.last_match[1] if ip =~ /\[(.*?)\]/
      { host: ip, port: port&.to_i || 26_379 }
    end

    { sentinels: sentinels, role: :master }
  end
end
