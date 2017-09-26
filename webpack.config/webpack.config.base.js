'use strict';

const fs = require('fs')
const webpack = require('webpack');
const path = require('path');
const WebpackNotifierPlugin = require('webpack-notifier');
const ExtractTextPlugin = require('extract-text-webpack-plugin');
const PostCSSPlugin = require('postcss-loader');

// MAIN WEBPACK CONFIGURATION
const webpackBaseConfig = function(env) {

    return {

        context: __dirname + "/assets",

        entry: {
          application: [
            __dirname + "/../assets/javascripts/global.js",
            __dirname + "/../assets/stylesheets/global.scss",
          ]
        },

        // Newly compiled file configuration
        output: {

          // Save location of the newly compiled output file
          path: path.resolve(__dirname, "../public/assets"),

          // What to call the newly compiled output file
          // [name] will be replaced with the entry objects key value.
          filename: "javascripts/[name]-[hash].js",

          // Path webpack will reference for looking for public files. Important for dynamic codesplitting
          publicPath: "/assets/"

        },

        // Module Rules Systems => Configuration for webpack loaders
        module: {
          loaders: [
            {
              test: /\.js$/,
              exclude: /node_modules/,
              loader: 'babel-loader',
              query: {
                presets: ['es2015', 'stage-3']
              }
            }, {
              test: /\.scss$/,
              loader: ExtractTextPlugin.extract({
                fallback: 'style-loader',
                use: [
                  { loader: "css-loader", options: { sourceMap: true, importLoaders: 1, minimize: true } },
                  { loader: "resolve-url-loader", options: { sourceMap: true } },
                  { loader: "sass-loader", options: { sourceMap: true } },
                  { loader: "sass-bulk-import-loader", options: { sourceMap: true } },
                  { loader: "postcss-loader", options: { sourceMap: true } },
                ]
              })
            }, {
              test: /\.(woff|woff2|eot|ttf|otf)$/,
              exclude: /node_modules/,
              loader: 'file-loader',
              options: {
                name: "fonts/[name].[ext]",
                publicPath: '/assets/'
              }
            }, {
              test: /\.(svg|jpeg|jpg|png|gif)$/,
              exclude: /node_modules/,
              loader: 'file-loader',
              options: {
                name: "images/[name]-[hash].[ext]",
                publicPath: '/assets/'
              }
            }
          ]
        },

        // Plugins => Configure webpack plugins
        plugins: [

          // The DefinePlugin allows you to create global constants which can be configured at compile time.
          // Note: process.env.NODE_ENV is set within npm "scripts"
          new webpack.DefinePlugin({
            'process.env.NODE_ENV': JSON.stringify(process.env.NODE_ENV)
          }),

          new WebpackNotifierPlugin({ title: 'Webpack', alwaysNotify: true}),

          function() {

            // output the fingerprint
            this.plugin("done", function(stats) {
              let output = "ASSET_FINGERPRINT = \"" + stats.hash + "\""
              fs.writeFileSync("config/initializers/fingerprint.rb", output, "utf8");
            });

          },

        ]
    }
};

module.exports = webpackBaseConfig;
