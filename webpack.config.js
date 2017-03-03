const webpack = require('webpack');
const path = require('path');
const DEBUG = (process.argv.indexOf('--release') === -1);

module.exports = {
  entry: [
    'webpack-dev-server/client?http://localhost:3000',
    './src/containers/main.js',
    './src/stylesheets/main.scss'
  ],
  output: {
    path: path.resolve(__dirname, "build"),
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
  },
  plugins: [
    new webpack.DefinePlugin({
      "process.env": {
         NODE_ENV: JSON.stringify(DEBUG ? "development" : "production")
       }
    })
  ]
}