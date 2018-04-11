# frozen_string_literal: true

ActionView::Base.default_form_builder = FormBuilder
ActionView::Base.field_error_proc = ->(html, _) { html }
