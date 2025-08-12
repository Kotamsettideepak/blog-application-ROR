class CsrfTokenController < ApplicationController
  protect_from_forgery with: :exception
  def show
    render json: { csrfToken: form_authenticity_token }
  end
end
