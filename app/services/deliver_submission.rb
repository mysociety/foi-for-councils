# frozen_string_literal: true

##
# This service will deliver the associated submission request to the council,
# normally their case management software
#
class DeliverSubmission < SimpleDelegator
  delegate :contact, to: :foi_request

  def initialize(obj, case_management: nil)
    super(obj)
    @case_management = case_management || CaseManagement::Infreemation.new
  end

  def call
    submitted_request = case_management.submit_foi_request!(**attributes)
    update(state: Submission::DELIVERED, reference: submitted_request.reference)
  end

  protected

  attr_reader :case_management

  private

  def attributes
    { name: contact.full_name,
      email: contact.email,
      body: foi_request.body }
  end
end
