# frozen_string_literal: true

Rails.application.config.to_prepare do
  CaseManagement.current unless Rails.env.test?
end
