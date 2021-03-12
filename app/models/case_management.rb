# frozen_string_literal: true

##
# Load the current CaseManagement client for the current environment.
#
module CaseManagement
  def self.current
    @current ||= "CaseManagement::#{config[:adapter]}".constantize.new
  end

  def self.current=(case_management)
    @current = case_management
  end

  def self.config
    @config ||= Rails.application.config_for(:case_management)

    "CaseManagement::#{@config[:adapter]}".
      constantize.
      configure!(@config[:client_params])

    @config
  end
end
