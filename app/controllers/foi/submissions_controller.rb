# frozen_string_literal: true

class Foi::SubmissionsController < ApplicationController
  include FindableFoiRequest

  def update
    redirect_to foi_request_sent_path(@foi_request)
  end

  def show; end
end
