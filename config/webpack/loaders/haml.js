module.exports = {
  test: /\.haml/,
  enforce: "pre",
  exclude: /node_modules/,
  use: [{
    loader: "hamljs-loader",
  }]
}
