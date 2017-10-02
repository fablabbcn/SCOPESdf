const webpack = require('webpack');
const webpackMerge = require('webpack-merge');
const ExtractTextPlugin = require('extract-text-webpack-plugin');
const UglifyJSPlugin = require('uglifyjs-webpack-plugin')
const ManifestPlugin = require('webpack-manifest-plugin')

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