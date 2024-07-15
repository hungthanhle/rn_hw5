class BookingsController < ApplicationController
  skip_before_action :verify_authenticity_token
  include BookingsHelper

  def create
    $redis.set("key", "value", ex: 10) #10s
    render json: {success: true, data: booking_params.permit!.to_h}
  end

  def booking_params
    params.permit(:flight_id, :seat_no, :passenger_id)
  end
end
