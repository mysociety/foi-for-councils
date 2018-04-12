# frozen_string_literal: true

##
# This Form Builder provides helper methods to output form validation errors
# with correct CSS classes from GovUK elements.
#
# See: http://govuk-elements.herokuapp.com/form-elements/example-form-elements/
#
class FormBuilder < ActionView::Helpers::FormBuilder
  def group(method, options = {}, &block)
    raise(ArgumentError, 'require a block') unless block_given?
    options[:class] = [options[:class]] << 'form-group-error' if error?(method)
    @template.content_tag(:div, options, &block)
  end

  def error(method = nil)
    error_message = error_message_for(method) if method
    return unless error_message
    @template.content_tag(:span, error_message, class: 'error-message')
  end

  private

  def error?(method)
    @object.errors.include?(method)
  end

  def error_message_for(method)
    return unless error?(method)
    @object.errors.full_messages_for(method)[0]
  end
end
