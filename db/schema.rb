# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 0) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "aircrafts_data", primary_key: "aircraft_code", id: { type: :string, limit: 3, comment: "Aircraft code, IATA" }, comment: "Aircrafts (internal data)", force: :cascade do |t|
    t.jsonb "model", null: false, comment: "Aircraft model"
    t.integer "range", null: false, comment: "Maximal flying distance, km"
    t.check_constraint "range > 0", name: "aircrafts_range_check"
  end

  create_table "airports_data", primary_key: "airport_code", id: { type: :string, limit: 3, comment: "Airport code" }, comment: "Airports (internal data)", force: :cascade do |t|
    t.jsonb "airport_name", null: false, comment: "Airport name"
    t.jsonb "city", null: false, comment: "City"
    t.point "coordinates", null: false, comment: "Airport coordinates (longitude and latitude)"
    t.text "timezone", null: false, comment: "Airport time zone"
  end

  create_table "boarding_passes", primary_key: ["ticket_no", "flight_id"], comment: "Boarding passes", force: :cascade do |t|
    t.string "ticket_no", limit: 13, null: false, comment: "Ticket number"
    t.integer "flight_id", null: false, comment: "Flight ID"
    t.integer "boarding_no", null: false, comment: "Boarding pass number"
    t.string "seat_no", limit: 4, null: false, comment: "Seat number"
    t.index ["flight_id", "boarding_no"], name: "boarding_passes_flight_id_boarding_no_key", unique: true
    t.index ["flight_id", "seat_no"], name: "boarding_passes_flight_id_seat_no_key", unique: true
  end

  create_table "bookings", primary_key: "book_ref", id: { type: :string, limit: 6, comment: "Booking number" }, comment: "Bookings", force: :cascade do |t|
    t.timestamptz "book_date", null: false, comment: "Booking date"
    t.decimal "total_amount", precision: 10, scale: 2, null: false, comment: "Total booking cost"
  end

  create_table "flights", primary_key: "flight_id", id: { type: :serial, comment: "Flight ID" }, comment: "Flights", force: :cascade do |t|
    t.string "flight_no", limit: 6, null: false, comment: "Flight number"
    t.timestamptz "scheduled_departure", null: false, comment: "Scheduled departure time"
    t.timestamptz "scheduled_arrival", null: false, comment: "Scheduled arrival time"
    t.string "departure_airport", limit: 3, null: false, comment: "Airport of departure"
    t.string "arrival_airport", limit: 3, null: false, comment: "Airport of arrival"
    t.string "status", limit: 20, null: false, comment: "Flight status"
    t.string "aircraft_code", limit: 3, null: false, comment: "Aircraft code, IATA"
    t.timestamptz "actual_departure", comment: "Actual departure time"
    t.timestamptz "actual_arrival", comment: "Actual arrival time"
    t.index ["flight_no", "scheduled_departure"], name: "flights_flight_no_scheduled_departure_key", unique: true
    t.check_constraint "actual_arrival IS NULL OR actual_departure IS NOT NULL AND actual_arrival IS NOT NULL AND actual_arrival > actual_departure", name: "flights_check1"
    t.check_constraint "scheduled_arrival > scheduled_departure", name: "flights_check"
    t.check_constraint "status::text = ANY (ARRAY['On Time'::character varying::text, 'Delayed'::character varying::text, 'Departed'::character varying::text, 'Arrived'::character varying::text, 'Scheduled'::character varying::text, 'Cancelled'::character varying::text])", name: "flights_status_check"
  end

  create_table "seats", primary_key: ["aircraft_code", "seat_no"], comment: "Seats", force: :cascade do |t|
    t.string "aircraft_code", limit: 3, null: false, comment: "Aircraft code, IATA"
    t.string "seat_no", limit: 4, null: false, comment: "Seat number"
    t.string "fare_conditions", limit: 10, null: false, comment: "Travel class"
    t.check_constraint "fare_conditions::text = ANY (ARRAY['Economy'::character varying::text, 'Comfort'::character varying::text, 'Business'::character varying::text])", name: "seats_fare_conditions_check"
  end

  create_table "ticket_flights", primary_key: ["ticket_no", "flight_id"], comment: "Flight segment", force: :cascade do |t|
    t.string "ticket_no", limit: 13, null: false, comment: "Ticket number"
    t.integer "flight_id", null: false, comment: "Flight ID"
    t.string "fare_conditions", limit: 10, null: false, comment: "Travel class"
    t.decimal "amount", precision: 10, scale: 2, null: false, comment: "Travel cost"
    t.check_constraint "amount >= 0::numeric", name: "ticket_flights_amount_check"
    t.check_constraint "fare_conditions::text = ANY (ARRAY['Economy'::character varying::text, 'Comfort'::character varying::text, 'Business'::character varying::text])", name: "ticket_flights_fare_conditions_check"
  end

  create_table "tickets", primary_key: "ticket_no", id: { type: :string, limit: 13, comment: "Ticket number" }, comment: "Tickets", force: :cascade do |t|
    t.string "book_ref", limit: 6, null: false, comment: "Booking number"
    t.string "passenger_id", limit: 20, null: false, comment: "Passenger ID"
    t.text "passenger_name", null: false, comment: "Passenger name"
    t.jsonb "contact_data", comment: "Passenger contact information"
    t.index ["passenger_id"], name: "idx_tickets_passenger_id"
  end

  add_foreign_key "boarding_passes", "ticket_flights", column: "ticket_no", primary_key: "ticket_no", name: "boarding_passes_ticket_no_fkey"
  add_foreign_key "flights", "aircrafts_data", column: "aircraft_code", primary_key: "aircraft_code", name: "flights_aircraft_code_fkey"
  add_foreign_key "flights", "airports_data", column: "arrival_airport", primary_key: "airport_code", name: "flights_arrival_airport_fkey"
  add_foreign_key "flights", "airports_data", column: "departure_airport", primary_key: "airport_code", name: "flights_departure_airport_fkey"
  add_foreign_key "seats", "aircrafts_data", column: "aircraft_code", primary_key: "aircraft_code", name: "seats_aircraft_code_fkey", on_delete: :cascade
  add_foreign_key "ticket_flights", "flights", primary_key: "flight_id", name: "ticket_flights_flight_id_fkey"
  add_foreign_key "ticket_flights", "tickets", column: "ticket_no", primary_key: "ticket_no", name: "ticket_flights_ticket_no_fkey"
  add_foreign_key "tickets", "bookings", column: "book_ref", primary_key: "book_ref", name: "tickets_book_ref_fkey"
end
