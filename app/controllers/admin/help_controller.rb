# frozen_string_literal: true

module Admin
  ##
  # Provide inline help to remind Admins how to use the system.
  #
  class HelpController < AdminController
    def index
      @case_management = CaseManagement.current
    end
  end
end
