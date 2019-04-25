# web-app-tools

Web app packages, all in 1 without bloating.

[![CircleCI](https://circleci.com/gh/dk00/web-app-tools.svg?style=svg)](https://circleci.com/gh/dk00/web-app-tools)
[![coverage](https://codecov.io/gh/dk00/web-app-tools/branch/master/graph/badge.svg)](https://codecov.io/gh/dk00/web-app-tools)
[![npm](https://img.shields.io/npm/v/web-app-tools.svg)](https://npm.im/web-app-tools)
[![dependencies](https://david-dm.org/dk00/web-app-tools/status.svg)](https://david-dm.org/dk00/web-app-tools)

Yet another customized `react-scripts`, with minimal dependencies and customizations for building web apps.

## Getting Started

Make sure [yarn] is installed, it's required to enable [PnP] at this time.

[yarn]: https://yarnpkg.com/en/docs/install
[PnP]: https://gapintelligence.com/blog/2018/yarn-plug-n-play-vs-node_modules

```
yarn --pnp create u-app my-app
cd my-app
yarn start
```

**Folder Structure**

```
my-app/
  README.md
  package.json
  src/
    index.js
    app.jsx
    service-worker.js
  style/
    index.sass
  .gitignore
  .pnp/
  .pnp.js
```

## Design

**Ejecting**

You customize configurations without handling all of the configurations.

**Progressive Web App**

Service worker is registered by default in production build?

`index.html` with pre rendered app.
`manifest.json`

**Tiny Bundle**

[Preact](https://preactjs.com/) is used instead of React, this saves 32kB(90%), reduces load time of small apps greatly.

## Features

- React, Redux, Sass
- One Dependency: Essential elements to build web applications are provided.
- Good Defaults: Start with almost no configurations.
- Smart Configuration: Customize without entire configurations, write configurations only for needed parts and customize easily.
- Keep updated: since there's no ejection, we can simply upgrade this package.
- Tiny Bundle Size: Dependencies are carefully chosen to avoid bloating, tree shakable packages are used if possible.
- Offline Ready: Assets are cached for offline use and `manifest.json` is generated for adding to the home screen.

## Infrastructure

### `startApp(app, options)`

Render the app into DOM, and wire up HMR in development environment.

`app` is the top level component of the app.

**Options**

- `container`: DOM element (or CSS selector) to be mounted, default is `#root`.
- `env`: Target window to render, default is `window`. Inject DOM mocks when using server-side rendering.

### `enableHMR(init)`

Wrap a component, re-render with edited component when the module is built.

- `init(replaceApp)`: Callback function to setup HMR.

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

**Babel Options**

Option of JSX is `{pragma: 'h', pragmaFrag: 'fragment'}`, import `h` and `fragment` to use JSX.

```tsx
import {h, fragment} from 'web-app-tools'

const MyComponent = () =>
  <>
    <h1>My Component</h1>
  </>
```

## Redux Bindings

Provider to use Redux with Hooks.

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

Get the `store` object.

### `useStoreState(selector, props)`

Subscribe to store updates. returns the object `selector` returned.

`selector` is the function to derive data from state.

Every time the store is updated, `selector` is called to get derived data,
 and initiate update of the component if derived data is changed(shallow equality).

If `selector` returned with new objects, then the component will update on every store update. So `selector` should compose result with objects from state, or use `reselect`.

## The Stack

Redux binding, routing, shared state and some essential features, all integrated into one provider, and completely opted-in.

### `<StackProvider reducer={{}} initialState={{}} actions={[]}>`

Replace `<StoreProvider>` with this to enable following features.

## Routing

Declarative routing like [React Router](https://reacttraining.com/react-router/web), provides minimal features and costs minimal.

### `<Route path="/" exact render={}>`

### `<NavLink to="/" type="a" others={}>`

### `navigate(to)`

An action creator for `history.push()`.

`to` is same as `to` of `<NavLink>`.

## Shared State

Shared state with minimal code, managed by Redux.

Data is modeled as collections of documents, you can store data to state and retrieve it.

A collection is an ordered set of documents of the same type, a document can be referenced by many collections.

A document is an serializable JavaScript object that have unique `id` (among objects of the same type).

Avoid relying on state shape, it might change, always retrieve collections from the state with selectors.

### `[state, setState] = useSharedState(id, initialValue)`

Global version of `useState`, `state` value is shared across components.

On first render, state will be set to `initialValue` if the value in the state is `undefined`.

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

### Selectors

#### `getDocument({type='app', id='shared'})`

Get document values of specified `type` and `id`.

#### `getCollection(state, {type, name='default'})`

Get collection of specified name, returns a list of `id` and an object contains values of each `id`

**Example**

```js
useStoreState(state => {
  # Get all users
  const users = getCollection(state, {name: 'user'})
  /* returns
  {
    byId: {
      2: {
        id: 2,
        name: 'alice'
      },
      3: {
        id: 3,
        name: 'bob'
      }
    },
    documents: [2, 3]  
  }
  */
})
```

### Actions

#### `updateDocument({type='app', id='shared', values})`

Update specified document in state, will merge and overwrite existing values.

#### `replaceCollection({type='app', name=type, documents})`

`type` can be omitted when replacing existing collections.

```js
const {dispatch} = useStore()

// Update posts
dispatch(replaceCollection({
  name: 'new-posts',
  type: 'post',
  documents: [{
    id: 'post1',
    body: '...'
  }, {
    id: 'post2',
    body: '...'
  }]
}))
```

#### `addToEnd({type='app', name=type, documents})`

Add documents to the end of specified collection.

#### `addToStart({type='app', name=type, documents})`

Add documents to the start of collection named `name`.

#### `removeDocuments({type='app', name=type, documents})`

Remove documents from a collection. Other collection can still reference these documents.

```js
dispatch(removeDocuments({
  type: 'post',
  documents: [2, 3]
}))
```

## Visual Effects

### `<CountTo value="0" step="1">`

Renders a numbers that counts up from 0.

### `<ActiveAbove>`

Wrap nested elements with `<div>`, add `active` class only when the element is scrolled above of fold.
