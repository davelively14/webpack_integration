# WebpackIntegration

This is my "how to" setup for using webpack instead of brunch. I lifted most of this from Matthew Lehner's blog post, ["Using Webpack with Phoenix and Elixir"](http://matthewlehner.net/using-webpack-with-phoenix-and-elixir/), however some of the configuration requires some deviation from the original text.

## Initializing the app

Despite what I expected, we don't use the `--no-brunch` flag. If you use that, it assumes that you will be managing your front end assets statically, so it's easier to remove the brunch configurations than to re-order the directories.

First up: create the app. Ensure that you **say no** when asked to install dependencies.
```
mix phoenix.new name_of_app
```

In the root directory of the new app, remove the file `brunch-config.js`.

Clear out the vast majority of the `package.json` file. Make it look like this:
```
{
  "repository": {},
  "dependencies": {}
}
```

## Adding webpack

***Deviation***
If you're going to use git with a remote, it's easier to do it now. Next step is npm init, where you can "register" your remote git.
***End Deviation***

Initialize npm from the root directory:
***Deviation***
Within `package.json`, I specified the output file as `./priv/static/js/app.js`. If you went with the default (`app.js`) during npm init, you will have to manually enter it under the `"main"` property.
***End Deviation***
```
npm init
```


Install webpack:
```
npm install --save-dev webpack
```

Create a file in the root directory called `webpack.config.js` and create a basic webpack configuration that tells the service where to find `app.js` and where to compile it to:
```
module.exports = {
  entry: "./web/static/js/app.js",
  output: {
    path: "./priv/static/js",
    filename: "app.js"
  }
}
```

In order to run webpack using the preferred cmd line options using `npm start` command, we have to add the following to the `script` section of the `package.json` file:
```
{
  "scripts": {
    "start": "webpack --watch-stdin --progress --color"
  }
}
```

Now we can tell Phoenix to run webpack as a watcher when running the development server. Open the `config/dev.exs` file and change the `watcher` property to match the final line in this block of code:
```
config :webpack_integration, WebpackIntegration.Endpoint,
  http: [port: 4000],
  debug_errors: true,
  code_reloader: true,
  check_origin: false,
  watchers: [npm: ["start", cd: Path.expand("../", __DIR__)]]
```
***Deviation Note:*** We had to add the `cd: Path.expand("../", __DIR__)` portion of that path. The root used to be the default path, but that has since been deprecated.

In order to ensure our setup is complete, open the `web/static/js/app.js` file, comment out `import "phoenix_html"`, and add the `alert` function below:
```
// import "phoenix_html"
alert('webpack compiled me')
```

We can now install the dependencies, setup the database, and run the server:
```
mix deps.get
mix ecto.create
mix phoenix.server
```

And open [http://localhost:4000](http://localhost:4000). You should get a pop-up alert, telling you that webpack compiled it, and then be greeted by a non-CSS webpage.

## Adding Babel and CSS Support
