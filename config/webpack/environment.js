const { environment } = require('@rails/webpacker')

module.exports = environment

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
