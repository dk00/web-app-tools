import
  redux: {create-store}
  \./react : {h, render}
  \./recompose : {with-context}
  \../utils : {deep-merge}
  \./actions : {compose-reduce}
  \./collection : {reduce-collection: collection, reduce-data: data}

function craft-reduce {reduce}
  compose-reduce Object.assign {collection, data} reduce

function initial-state reduce, {env, state={}}
  deep-merge state,
    collection: {}
    data:
      app: location: env.location{pathname}

function craft-store {env}: options
  reduce = craft-reduce options
  state = initial-state reduce, options
  create-store reduce, state, env?__REDUX_DEVTOOLS_EXTENSION__?!

function with-default {env=@ || window, el=\#root initialize, init=initialize}: options
  Object.assign {} options, {env, el, init}

function create-context store, {base-url, collections}
  options = {base-url, collections}
  {store, options}

function start-app app, user-options
  require \preact/devtools if module.hot
  {env, el, init} = options = with-default user-options

  store = craft-store options
  with-store = with-context create-context store, options

  container = env.document.query-selector el
  root = container?first-child
  mount = env.render || render
  replace-app = !-> root := mount (h with-store it), container, root
  replace-app app

  if module.hot
    replace-options = !-> store.replace-reducer craft-reduce it
    init {replace-app, replace-options}
  else env.navigator.service-worker?register \/sw.js

export default: start-app
