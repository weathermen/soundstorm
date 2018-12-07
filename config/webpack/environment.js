const { environment } = require("@rails/webpacker")

environment.loaders.append("haml", {
  test: /\.html\.haml$/,
  use: "haml-haml-loader"
})

module.exports = environment
