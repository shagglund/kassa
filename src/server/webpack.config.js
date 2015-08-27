import { join } from 'path';
import { NoErrorsPlugin } from 'webpack';

export const config = {
    devServer: {
        contentBase: './client',
    },
    entry: [
      'webpack/hot/only-dev-server',
      './client/app.jsx',
    ],
    output: {
        path: join(__dirname, 'client', 'dist'),
        filename: 'bundle.js',
    },
    module: {
        loaders: [
          { test: /\.jsx$/, loaders: [ 'react-hot', 'babel' ], exclude: /node_modules/ },
          { test: /\.js$/, exclude: /node_modules/, loader: 'babel' },
          { test: /\.css$/, loader: 'style!css?minimize!' },
          { test: /\.less$/, loader: 'style!css?minimize!less' },
          { test: /\.jpe?g|\.gif|\.png|\.svg|\.woff|\.woff2|\.ttf|\.eot/, loader: 'file' },
          { test: /\.json$/, loader: 'json' },
        ],
    },
    plugins: [
      new NoErrorsPlugin(),
    ],
};
