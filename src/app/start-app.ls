import
  './react': {h, render}
  './recompose': {with-context}
  './store': craft-store
  './history': {sync-history, update-location}
  './local-config': {sync-config}

function with-default {env=@ || window, el='#root' init, actions=[]}: options
  actions =
    []concat actions, update-location env.location
  Object.assign {} options, {env, el, init}

function create-context store, {base-url, collections}
  options = {base-url, collections}
  {store, options}

function listen-actions store, env
  env.add-event-listener \message (data: {source, action}) ->
    if source == \app then store.dispatch action

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
  if env.window
    sync-config store, env
    sync-history store, env
    listen-actions store, env

  if module.hot
    replace-options = !-> store.replace-reducer craft-reduce it
    init {replace-app, replace-options}
  else env.navigator.service-worker?register \/service-worker.js

export default: start-app
