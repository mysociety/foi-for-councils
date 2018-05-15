# frozen_string_literal: true

require 'exception_notification/rails'
require 'exception_notification/sidekiq'

ExceptionNotification.configure do |config|
  # Ignore additional exception types.
  # ActiveRecord::RecordNotFound, Mongoid::Errors::DocumentNotFound,
  # AbstractController::ActionNotFound and ActionController::RoutingError are
  # already added.
  config.ignored_exceptions += %w[DeliverSubmissionWorker::RetryJob]

  # Adds a condition to decide when an exception must be ignored or not.
  # The ignore_if method can be invoked multiple times to add extra conditions.
  config.ignore_if do |_exception, _options|
    !Rails.env.production?
  end

  # Email notifier sends notifications by email.
  recipients = ENV['EXCEPTION_NOTIFICATIONS_TO']
  recipients = recipients.split(',').map(&:chomp) if recipients

  config.add_notifier :email,
                      email_prefix: '[foi-for-councils][ERROR] ',
                      sender_address: ENV['EXCEPTION_NOTIFICATIONS_FROM'],
                      exception_recipients: recipients
end
