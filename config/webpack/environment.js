const { environment } = require("@rails/webpacker")

environment.loaders.append("haml", {
  test: /\.html\.haml$/,
  use: "hamljs-loader"
})

module.exports = environment
