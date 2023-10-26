const axios = require("axios");
require("../configs");

const instance = axios.create({
  baseURL: process.env.BASE_URL,
});

instance.interceptors.request.use(
  async (config) => {
    const token = process.env.ZEROTIER_AUTH_TOKEN;

    if (token) {
      // eslint-disable-next-line no-param-reassign
      config.headers.Authorization = `token ${token}`;
    }

    return config;
  },

  (err) => {
    return Promise.reject(err);
  }
);
module.exports = instance;
