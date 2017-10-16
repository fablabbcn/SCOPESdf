const ExtractTextPlugin = require('extract-text-webpack-plugin');
const fs = require('fs')
const ManifestPlugin = require('webpack-manifest-plugin')
const UglifyJSPlugin = require('uglifyjs-webpack-plugin')
const webpack = require('webpack');
const webpackMerge = require('webpack-merge');

// Set the webpack production configurations
const webpackProductionConfig = {
    // Newly compiled file configuration
    output: {
      filename: "javascripts/[name].[hash].js",
    },

    // Plugins => Configure webpack plugins
    plugins: [

      new ManifestPlugin({
        basePath: "public/assets/"
      }),

      new ExtractTextPlugin({
          filename: "stylesheets/[name].[hash].css"
      }),

      function() {

        // output the fingerprint
        this.plugin("done", function(stats) {
          let output = "ASSET_FINGERPRINT = \"" + stats.hash + "\""
          fs.writeFileSync("config/initializers/fingerprint.rb", output, "utf8");
        });

      },

    ]
};


/*
  ******************************
  * Build Webpack Configuration
  * Note: Done with webpackMerge
  ******************************
*/
const webpackBaseConfig = require('./webpack.config.base.js');

function webpackMergeConfig(env) {
  return webpackMerge(webpackBaseConfig(env), webpackProductionConfig);
};

module.exports = webpackMergeConfig;
