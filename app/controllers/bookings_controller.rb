class BookingsController < ApplicationController
  skip_before_action :verify_authenticity_token
  include BookingsHelper

  def create
    # https://github.com/redis/redis-rb
    # https://www.rubydoc.info/github/redis/redis-rb/Redis/Commands/Strings#set-instance_method
    request_time = Time.now
    flight_id = params[:flight_id]
    seat_no = params[:seat_no]
    
    resource_key = "booking:#{flight_id}_#{seat_no}"
    ttl = 3600 # 1 hour
    
    if acquire_lock(resource_key, ttl)
      # @booking = Booking.new(booking_params)
      # @booking.save
      sleep 10 # 10s
      release_lock(resource_key)
      return render json: {
        success: true,
        data: booking_params.permit!.to_h,
        request_time: request_time,
        response_time: Time.now,
      }
    else
      render json: {
        success: false,
        message: "Resource is currently locked. Please try again later.",
        request_time: request_time,
        response_time: Time.now,
      }, status: :conflict
    end
  end

  def booking_params
    params.permit(:flight_id, :seat_no, :passenger_id)
  end

  def acquire_lock(key, ttl)
    $redis.set(key, "locked", nx: true, ex: ttl)
  end

  def release_lock(key)
    $redis.del(key)
  end
end
