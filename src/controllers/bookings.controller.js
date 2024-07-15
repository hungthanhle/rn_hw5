const { bookingsService } = require('../services');

const create = async (req, res) => {
  const data = await bookingsService.create(req.body);
  res.status(200).send({ success: true, data: data });
};

module.exports = {
  create,
};
