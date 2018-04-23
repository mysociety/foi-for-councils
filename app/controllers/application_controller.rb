# frozen_string_literal: true

class ApplicationController < ActionController::Base # :nodoc:
  before_action :authenticate

  private

  def authenticate
    return unless ENV.key?('HTTP_AUTH_PASSWORD')
    authenticate_or_request_with_http_basic do |name, password|
      name == 'hackney-foi' && password == ENV['HTTP_AUTH_PASSWORD']
    end
  end
end
