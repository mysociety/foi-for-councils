# frozen_string_literal: true

class Foi::ContactsController < ApplicationController
  include FindableFoiRequest

  before_action :find_or_build_contact

  def show
    @contact = @foi_request.contact || @foi_request.build_contact
  end

  def update
    if @contact.update(contact_params)
      redirect_to @foi_request
    else
      render :show
    end
  end

  private

  def find_or_build_contact
    @contact = @foi_request.contact || @foi_request.build_contact
  end

  def contact_params
    params.require(:contact).permit(:full_name, :email)
  end
end
