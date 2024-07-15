const express = require('express');
const authRoute = require('./bookings.route');

const router = express.Router();

const routes = [
  {
    path: '/bookings',
    route: authRoute,
  },
];

routes.forEach((route) => {
  router.use(route.path, route.route);
});

module.exports = router;
