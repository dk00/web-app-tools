# web-app-tools

Web app packages, all in 1 without bloating.

[![build status](https://travis-ci.org/dk00/web-app-tools.svg)](https://travis-ci.org/dk00/web-app-tools)
[![coverage](https://codecov.io/gh/dk00/web-app-tools/branch/master/graph/badge.svg)](https://codecov.io/gh/dk00/web-app-tools)
[![npm](https://img.shields.io/npm/v/web-app-tools.svg)](https://npm.im/web-app-tools)
[![dependencies](https://david-dm.org/dk00/web-app-tools/status.svg)](https://david-dm.org/dk00/web-app-tools)

https://medium.com/@ericclemmons/javascript-fatigue-48d4011b6fc4

Alternative to `react-scripts`, without unnecessary things and with some customizations.

# Why

Customizations without having to customize everything.

After [ejecting](https://medium.com/@timarney/but-i-dont-wanna-eject-3e3da5826e39) from `create-react-app`, we can customize everything, and we have to customize everything. There's no way back.

# Features

- One Dependency: Essential elements to build web applications are provided.
- Good Defaults: Start with almost no configurations.
- Simple Configuration: Customize without entire configurations, write configurations only for needed parts and customize easily.
- Keep updating
- Tiny Bundle Size: Dependencies are carefully chosen to avoid bloating, tree shakable packages are used if possible.
- Offline

# Quick Start

Create the project directory:

```sh
mkdir my-web-app
cd my-web-app
npm init -y
npm i web-app-tools@next
```

And these files:

**package.json**

```json
{
  "name": "my-app",
  "version": "0.0.1",
  "description": "My App",
  "scripts": {
    "start": "webpack-serve",
    "build": "rimraf www/*js && webpack -p",
    "pretest": "npm run build",
    "test": "nyc --instrument false --source-map false -r text -r html -r json -r lcovonly node test"
  },
  "license": "Unlicensed",
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

Go to http://localhost:8080
