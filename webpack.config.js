module.exports = {
    entry: "./app/assets/coffee/main.coffee",
    output: {
        path: __dirname,
        filename: "app/bundle.js"
    },
    module: {
        loaders: [
            { test: /\.coffee$/, loader: "coffee-loader" }
        ]
    },
    resolve: {
        extensions:['','.js', '.coffee']
    }
}
