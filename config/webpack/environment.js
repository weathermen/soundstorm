const { environment } = require("@rails/webpacker")
const haml = require("./loaders/haml")

environment.loaders.prepend("haml", haml)

module.exports = environment
