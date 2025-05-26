const path = require('path');
const HtmlWebpackPlugin = require('html-webpack-plugin');
const CopyWebpackPlugin = require('copy-webpack-plugin');

module.exports = {
    mode: 'development',
    entry: './octopus-erp/index.js',
    output: {
        filename: 'bundle.js',
        path: path.resolve(__dirname, 'dist'),
        clean: true,
    },
    devServer: {
        static: [
            {
                directory: path.join(__dirname, 'public'),
            },
            {
                directory: path.join(__dirname, 'octopus-erp'),
            },
        ],
        port: 8081,
        proxy: [
            {
                context: ['/octopus'],
                target: 'http://newdev2.ejcop.com:1081',
                changeOrigin: true,
                pathRewrite: {
                    '^/octopus': '/octopus',
                },
            },
        ],
    },
    module: {
        rules: [
            {
                test: /\.css$/i,
                use: ['style-loader', 'css-loader'],
            }
        ]
    },
    plugins: [
        new HtmlWebpackPlugin({
            template: './octopus-erp/contractList.html'
        }),
        new CopyWebpackPlugin({
            patterns: [
                { from: 'octopus-erp/css', to: 'css' },
                { from: 'octopus-erp/js', to: 'js' }
            ]
        })
    ]
};
