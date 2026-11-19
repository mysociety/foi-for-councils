# frozen_string_literal: true

ActionView::Base.default_form_builder = GovukElementsFormBuilder::FormBuilder

# Rails 7.0 runs this proc on the view, so the gem's own proc can no longer
# find the method without an explicit receiver.
ActionView::Base.field_error_proc = proc do |html_tag, instance|
  GovukElementsFormBuilder::FormBuilder.
    send(:add_error_to_html_tag!, html_tag, instance)
end
