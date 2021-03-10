# frozen_string_literal: true

##
# This worker is responsible for sending Requests to case management platforms
#
class DeliverSubmissionWorker
  include Sidekiq::Worker

  def perform(id)
    Current.set(case_management: CaseManagement::Infreemation.new) do
      submission = Submission.deliverable.find_by(id: id)
      return unless submission

      submission.with_lock { submission.deliver }
    end
  end
end
