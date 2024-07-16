```
rails db:migrate

rails s
```
```
curl -X POST http://localhost:3000/bookings -H "Content-Type: application/json" -d '{"flight_id": 187662, "seat_no": "10C", "passenger_id": "4030 855525"}' & 
curl -X POST http://localhost:3000/bookings -H "Content-Type: application/json" -d '{"flight_id": 187662, "seat_no": "10C", "passenger_id": "4030 855526"}' &
```

```
REST Client requests:
requests/requests.http
```
