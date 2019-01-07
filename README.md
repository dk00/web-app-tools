# web-app-tools

Web app packages, all in 1 without bloating.

[![build status](https://travis-ci.org/dk00/web-app-tools.svg)](https://travis-ci.org/dk00/web-app-tools)
[![coverage](https://codecov.io/gh/dk00/web-app-tools/branch/master/graph/badge.svg)](https://codecov.io/gh/dk00/web-app-tools)
[![npm](https://img.shields.io/npm/v/web-app-tools.svg)](https://npm.im/web-app-tools)
[![dependencies](https://david-dm.org/dk00/web-app-tools/status.svg)](https://david-dm.org/dk00/web-app-tools)

Yet another customized `react-scripts`, with minimal dependencies and customizations for building web apps.

## Why

After [ejecting](https://medium.com/@timarney/but-i-dont-wanna-eject-3e3da5826e39) from `create-react-app`, we gain full control of everything, and we must manage all of them. There's no way back.

Instead of no configuration, we write minimal configurations only for customized parts.

## Features

- One Dependency: Essential elements to build web applications are provided.
- Good Defaults: Start with almost no configurations.
- Smart Configuration: Customize without entire configurations, write configurations only for needed parts and customize easily.
- Keep updated: since there's no ejection, we can simply upgrade this package.
- Tiny Bundle Size: Dependencies are carefully chosen to avoid bloating, tree shakable packages are used if possible.
- Offline Ready: Assets are cached for offline use and `manifest.json` is generated for adding to the home screen.

## Getting Started

Make sure [yarn] is installed, it's required to enable [PnP] at this time.

[PnP] is ⚡lighting fast⚡, you should try it!

[yarn]: https://yarnpkg.com/en/docs/install
[PnP]: https://gapintelligence.com/blog/2018/yarn-plug-n-play-vs-node_modules

Create the project directory:

```sh
mkdir my-web-app
cd my-web-app
yarn init -y
yarn add -D web-app-tools
```

And these files:

**package.json**

```json
{
  "name": "my-app",
  "version": "0.0.1",
  "description": "My App",
  "scripts": {
    "start": "webpack-dev-server",
    "build": "rimraf www/*js && webpack -p",
    "pretest": "npm run build",
    "test": "nyc --instrument false --source-map false -r text -r html -r json -r lcovonly node test"
  },
  "license": "Unlicensed",
  "installConfig": {
    "pnp": true
  },
  "devDependencies": {
    "rimraf": "^2.6.2",
    "web-app-tools": "next",
    "webpack": "^4.26.1",
    "webpack-dev-server": "^0.4.2"
  }
}
```

Use `webpackConfig` to generate webpack options:

**src/webpack.config.js**

```js
const {webpackConfig} = require('web-app-tools')

module.exports = webpackConfig({name: 'My Web App'})
```

Top-level component:

**src/app.jsx**

```jsx
import {h} from 'web-app-tools'

const app = () =>
  <div>
    <h1>My App</h1>
  </div>

export default app
```

Entry file, start the app with HMR enabled:

**src/index.js**

```js
import {startApp} from 'web-app-tools'
import app from './app'
import options from './options'

const init = ({replaceApp, replaceOptions}) => {
  if (module.hot) {
    module.hot.accept('./app', () => replaceApp(app))
    module.hot.accept('./options', () => replaceOptions(options))
  }
}

startApp(app, Object.assign({init}, options))
```

Start development server:

```sh
npm start
```

Go to http://localhost:8080 and start hacking!

## API

### `webpackConfig()`

Return a [Webpack config object](https://webpack.js.org/configuration/configuration-types/#exporting-a-function).

Things removed:

- `case-sensitive-paths-webpack-plugin`
- `postcss-safe-parser`
- `react-dev-utils`
  - `InlineChunkHtmlPlugin`
  - `InterpolateHtmlPlugin`
  - `WatchMissingNodeModulesPlugin`
  - `ModuleScopePlugin`
  - `getCSSModuleLocalIdent`

Things added:

- PnP
- `pwa-utils` for `manifest.json` and `index.html`

**Options**

- `name`: Name of the application, will appear as tab title and home screen app name.

**Optional Options**

- `outputPath`: [`output.path`](https://webpack.js.org/configuration/output/#output-path) of Webpack, default to `www` for Cordova.
- `webApp`: Options for generating [`manifest.json`](https://developers.google.com/web/fundamentals/web-app-manifest/)
- `workbox`: Options for [`GenerateSW`](https://developers.google.com/web/tools/workbox/reference-docs/latest/module-workbox-webpack-plugin-GenerateSW) plugin from `workbox-webpack-plugin`
- `env`: Names of used environment variables, will be passed to [EnvironmentPlugin](https://webpack.js.org/plugins/environment-plugin/)

### `startApp()`
