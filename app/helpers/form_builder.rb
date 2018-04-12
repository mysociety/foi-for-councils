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

  def hint(text = nil)
    return unless text
    @template.content_tag(:span, text, class: 'form-hint')
  end

  def label(method, *args, &block)
    options = args.extract_options!
    hint_text = options.delete(:hint)
    block ||= -> { args[0] }

    @template.label(@object_name, method, objectify_options(options)) do
      @template.safe_join(
        [block.call, label_extras(method, hint_text)]
      )
    end
  end

  private

  def error?(method)
    @object.errors.include?(method)
  end

  def error_message_for(method)
    return unless error?(method)
    @object.errors.full_messages_for(method)[0]
  end

  def label_extras(method, hint_text)
    @template.safe_join([hint(hint_text), error(method)])
  end
end
