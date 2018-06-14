import
  \./react : {h, render}
  \./recompose : {with-context}
  \./store : craft-store
  \./history : {sync-history, update-location}

function with-default {env=@ || window, el=\#root initialize, init=initialize}: options
  Object.assign {} options, {env, el, init}

function create-context store, {base-url, collections}
  options = {base-url, collections}
  {store, options}

function start-app app, user-options
  require \preact/devtools if module.hot
  {env, el, init} = options = with-default user-options

  store = craft-store Object.assign {} options, actions:
    []concat options.actions || [] update-location env.location
  with-store = with-context create-context store, options

  container = env.document.query-selector el
  root = container?first-child
  mount = env.render || render
  replace-app = !-> root := mount (h with-store it), container, root
  replace-app app
  sync-history store, env

  if module.hot
    replace-options = !-> store.replace-reducer craft-reduce it
    init {replace-app, replace-options}
  else env.navigator.service-worker?register \/sw.js

export default: start-app
