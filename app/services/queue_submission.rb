# frozen_string_literal: true

##
# This service queues the submission worker and updates the submission state. It
# also handles any errors connecting to the Redis instance.
#
class QueueSubmission < SimpleDelegator
  def call
    success = ActiveRecord::Base.transaction do
      begin
        jid = DeliverSubmissionWorker.perform_async(id)
        update(state: Submission::QUEUED, jid: jid)
      rescue Redis::BaseConnectionError
        raise ActiveRecord::Rollback
      end
    end

    update(state: Submission::UNQUEUED) unless success

    true
  end
end
