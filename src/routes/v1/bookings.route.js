const express = require('express');
const bookingsController = require('../../controllers/bookings.controller');

const router = express.Router();

router.post('/', bookingsController.create);

module.exports = router;
