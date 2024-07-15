class CreateBookings < ActiveRecord::Migration[7.0]
  def change
    create_table :bookings do |t|
      t.bigint :user_id
      t.bigint :seat_id

      t.timestamps
    end
  end
end
