import
  './react': {h, render, store-context}
  './hooks': {use-state, use-effect, use-context}
  './dom': {add-event-listener}
  './recompose': {with-context}
  './store': {craft-store, craft-reduce}
  './history': {sync-location, update-location}
  './local-config': {sync-config}

function with-default {env=@ || window, el='#root' init, actions=[]}: options
  actions = []concat actions, update-location env.location
  Object.assign {} options, {env, el, init}

function listen-actions store, env
  add-event-listener env, \message (data: {source, action}) ->
    if source == \app then store.dispatch action

function starter {app, env, store, setup}
  [config, set-config] = use-state {app}
  use-effect -> (setup {replace-app: -> set-config app: it}), []

  h store-context.Provider, value: store,
    h config.app

function start-app app, user-options
  {env, el, init} = options = with-default user-options
  store = craft-store options
  container = env.document.query-selector el
  mount = env.render || render

  setup = ({replace-app}) ->
    replace-options = !-> store.replace-reducer craft-reduce it
    handle-location = options.sync-location || sync-location
    clean-ups =
      sync-config store, env
      handle-location store, env
      listen-actions store, env
    init? {replace-app, replace-options}
    -> clean-ups.for-each -> it?!
  mount (h starter, {app, env, store, setup, ...options}), container

  if !module.hot
    env.navigator.service-worker?register \/service-worker.js

export default: start-app
