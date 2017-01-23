const webpack = require('webpack');
const path = require('path');

module.exports = {
  entry: [
    'webpack-dev-server/client?http://localhost:8080',
    './src/containers/main.js',
    './src/stylesheets/main.scss'
  ],
  output: {
    publicPath: '/public/',
    filename: 'bundle.js'
  },
  module: {
    loaders: [
      {
        test: /\.js?$/,
        loaders: ['react-hot-loader', 'babel-loader'],
        include: path.join(__dirname, 'src')
      },
      { 
        test: /\.css$/,
        loader: "style-loader!css-loader"
      },
      { 
        test: /\.scss$/, 
        loader: 'style!css!sass!'
      },
      {
        test: /\.(png|jpg|jpeg|gif)$|\.woff2?$|\.ttf$|\.eot$|\.svg$/,
        loader: 'file'
      },
    ]
  }
}