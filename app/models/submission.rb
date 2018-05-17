# frozen_string_literal: true

##
# This model represents the state of a submission to external case management
# software.
#
class Submission < ApplicationRecord
  UNQUEUED = 'unqueued'
  QUEUED = 'queued'
  DELIVERED = 'delivered'

  has_one :foi_request, dependent: :destroy

  validates :state, presence: true

  scope :queueable, -> { where(state: UNQUEUED) }
  scope :deliverable, -> { where(state: QUEUED) }
  scope :delivered, -> { where(state: DELIVERED) }
  scope :delivered_successfully, lambda {
    where(state: DELIVERED).where.not(reference: nil)
  }

  def queue
    QueueSubmission.new(self).call
  end

  def deliverable?
    state == QUEUED
  end

  def successfully_delivered?
    state == DELIVERED && reference    
  end

  def deliver
    DeliverSubmission.new(self).call
  end
end
