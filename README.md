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

- React, Redux, Sass
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

```tsx
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

const init = replaceApp => {
  if (module.hot) {
    module.hot.accept('./app', () => replaceApp(app))
  }
}

startApp(app, {init})
```

Start development server:

```sh
npm start
```

Go to http://localhost:8080 and start hacking!

## Infrastructure

### `startApp(app, options)`

Render the app into DOM, and wire up HMR in development environment.

`app` is the top level component of the app.

**Options**

- `container`: DOM element (or CSS selector) to be mounted, default is `#root`.
- `init(replaceApp)`: Callback function to setup HMR.
- `env`: Target window to render, default is `window`. Inject DOM mocks when using server-side rendering.

### `webpackConfig(options)`

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

## Redux Bindings

Provider to use Redux with Hooks that can be opted-in.

### `<StoreProvider reducer={{}} initialState={{}} actions={[]}>`

Create a Redux store and make it available to nested components, and wire up HMR in development environment.

**Props**

- `reducer` (function): The reducer function.
- `reducer` (object): See [`combineReducers`](https://redux.js.org/api/combinereducers).
- `initialState`
- `actions`: Additional actions to populate initial state.
- `init(replaceReducer)`: Setup HMR,

**Example**

```js
import reducers from './reducers'

const init = replaceReducer =>
  module.hot.accept('./reducers', replaceReducer)

const app = () =>
  <StoreProvider reducers={reducers} init={init}>
    <App />
  </StoreProvider>

export default app
```

### `useStore()`

### `useStoreState(selector, props)`

## The Stack

Redux binding, routing, shared state and some essential features, all integrated into one provider, and completely opted-in.

### `<StackProvider reducer={{}} initialState={{}} actions={[]}>`

Replace `<StoreProvider>` with this to enable following features.

## Routing

Declarative routing like [React Router](https://reacttraining.com/react-router/web), provides minimal features with minimal cost.

### `<Route path="/" exact render={}>`

### `<NavLink to="/" type="a" others={}>`

## Shared State

Shared state with minimal code, managed by Redux.

State shape might change, always retrieve collections from the state with selectors.

### `[state, setState] = useSharedState(id, initialValue)`

Like `useState` but `state` is syncing across components.

**Example**

```jsx

const PriceInput = () => {
  const [price, setPrice] = useSharedState('price', 0)
  return (
    <input type="number" value={price} onChange={e => setPrice(e.target.value)} />
  )
}

const AmountInput = () => {
  const [amount, setAmount] = useSharedState('amount', 0)
  return (
    <input type="number" value={amount} onChange={e => setAmount(e.target.value)} />
  )
}

const SubTotal = () => {
  const [price] = useSharedState('price')
  const [amount] = useSharedState('amount')
  return price * amount
}

const Order = () =>
<div>
  <label>
    Price:
    <PriceInput />
  </label>
  <label>
    Amount:
    <AmountInput />
  </label>
  <div>Sub total: <SubTotal /> </div>
</div>
```

### `getDocument({model='app', id='default'})`

### `getCollection({model, id='default'})`

**Example**

```js
useStoreState(state => {
  # Get all users
  const users = getCollection(state, {model: 'user'})
  /*
  [
    {
      id: 2,
      name: 'alice'
    },
    {
      id: 3,
      name: 'bob'
    }
  ]
  */
})
```

### `updateDocument({model='app', values})`

### `replaceCollection({model, id='default', models})`

```js
const {dispatch} = useStore()

// Update posts
dispatch({
  model: 'post',
  models: [{
    id: 'post1',
    body: '...'
  }, {
    id: 'post2',
    body: '...'
  }]
})
```

## Utility Components

Basic interactions.

### `<Toggle type="div" id="default">`

Renders an element with internal state alternating between `true` / `false` on click.

`active` class is added when its state is `true`, you can set active style rules by this CSS class.

**Props**

- `type`: Element type to be rendered.
- `id`: Identifier of shared state value. `useSharedState` with the same `id` returns the same value.

### `<ToogleTarget type="div" id="default">`

`<Toogle>` without `onClick` handlers.

### `<LinkedInput type="text" id="default">`

Renders an input element, with its value linked to shared state.

## Visual Effects

### `<CountTo value="0" step="1">`

Renders a numbers that counts up from 0.

### `<ActiveAbove>`

Wrap nested elements with `<div>`, add `active` class only when the element is scrolled above of fold.
