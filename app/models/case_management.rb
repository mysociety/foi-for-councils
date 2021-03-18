# frozen_string_literal: true

##
# Load the current CaseManagement client for the current environment.
#
module CaseManagement
  def self.constantize(name)
    name = name.dup
    name.prepend("#{self.name}::") unless name.starts_with?(self.name)
    name.constantize
  end

  def self.current
    @current ||= constantize(config[:adapter]).new
  end

  def self.current=(case_management)
    @current = case_management
  end

  def self.generate_url(published_request)
    constantize(published_request.case_management).new.
      generate_url(published_request)
  end

  def self.config
    @config ||= Rails.application.config_for(:case_management)
    constantize(@config[:adapter]).configure!(@config[:client_params])
    @config
  end
end
