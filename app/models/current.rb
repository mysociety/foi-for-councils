# frozen_string_literal: true

# Class to facilitate easy access to global, per-request attributes.
class Current < ActiveSupport::CurrentAttributes
  attribute :case_management
end
