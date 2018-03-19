import
  redux: {create-store}
  \./react : {h, render}
  \./recompose : {with-context}
  \./actions : {compose-reduce}
  \./collection : reduce: collection
  \./data : reduce: data

function craft-reduce options
  compose-reduce {collection, data}

function initial-state reduce, {env}
  collection: {}
  data:
    app: location: env.location.pathname

function with-default {env=@ || window, el=\#root}: options
  Object.assign {} options, {env, el}

function start-app app, original-options
  require \preact/devtools if module.hot
  {env, el, state: default-state} = options = with-default original-options

  reduce = craft-reduce options
  state = Object.assign {} (initial-state reduce, options), default-state
  store = create-store reduce, state, env?__REDUX_DEVTOOLS_EXTENSION__?!
  with-store = with-context {store}

  container = env.document.query-selector el
  root = container?first-child
  mount = env.render || render
  replace-app = !-> root := mount (h with-store it), container, root
  replace-app app

  env.navigator.service-worker?register \/sw.js if !module.hot
  Object.assign {}, if module.hot
    replace-app: replace-app
    replace-options: !-> store.replace-reducer craft-reduce it

export default: start-app
