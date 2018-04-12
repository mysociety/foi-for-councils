# frozen_string_literal: true

class ApplicationController < ActionController::Base
  self.view_paths += ['gems/hackney_template/source/views']
end
