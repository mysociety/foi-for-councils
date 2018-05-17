# frozen_string_literal: true

##
# This worker is responsible for sending Requests to case management platforms
#
class DeliverSubmissionWorker
  include Sidekiq::Worker
  include Sidekiq::Lock::Worker

  RetryJob = Class.new(RuntimeError)
  DeadJob = Class.new(RuntimeError)

  sidekiq_options lock: {
    timeout: 30.seconds.in_milliseconds,
    name: proc { |id, _timeout| "lock:submission_worker:#{id}" }
  }

  sidekiq_options retry: 3
  sidekiq_retries_exhausted do |msg, _ex|
    ExceptionNotifier.notify_exception DeadJob.new, data: msg
  end

  def perform(id)
    submission = Submission.deliverable.find_by(id: id)
    raise RetryJob, 'lock can not be acquired' unless lock.acquire!

    begin
      submission&.deliver
    ensure
      lock.release!
    end
  end
end
