# frozen_string_literal: true

# Finds and sets the current CaseManagement system.
module CurrentCaseManagement
  extend ActiveSupport::Concern

  included do
    before_action :set_current_case_management

    def set_current_case_management
      Current.case_management = CaseManagement::Infreemation.new
    end
  end
end
