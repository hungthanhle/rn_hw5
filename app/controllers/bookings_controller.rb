class BookingsController < ApplicationController
  skip_before_action :verify_authenticity_token
  include BookingsHelper

  def create
    render json: {success: true, data: params.permit!.to_h}
  end
end
