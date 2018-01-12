const environment = require('./environment')

module.exports = environment.toWebpackConfig()

resolve: {
  alias: {
    jquery: "jquery/src/jquery"
  }
};

plugins: [
  new webpack.ProvidePlugin({
    $: 'jquery',
    jQuery: 'jquery',
    jquery: 'jquery'
  })
]
