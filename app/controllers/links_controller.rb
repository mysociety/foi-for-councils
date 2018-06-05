# frozen_string_literal: true

##
# This controller is responsible for tracking the number of clicks on suggested
# resources
#
class LinksController < ApplicationController
  def show
    suggestion = FoiSuggestion.find(params[:id])
    suggestion.clicked!
    redirect_to suggestion.url
  end
end
