import
  './react': {h}
  './hooks': {use-effect}
  './store': {store-provider, use-store, use-store-state}
  './cache': {reduce-entities, update-document}
  './routing': {location-actions, navigate}

default-URL = 'http://localhost'

function sync-env {children}
  store = use-store!
  use-effect (!->
    window.add-event-listener \popstate ->
      store.dispatch navigate window.location
  ), []
  {href} = use-store-state ->
    {port, ...rest} = it.location
    others = if port then {port}
    Object.assign (new URL window.location), rest, others .{href}
  use-effect (!->
    history.push-state {} '' href
  ), [href]
  children

function stack-provider {reducer={} initial-state={} actions=[] init, children}
  setup-actions =
    navigate window.location
    update-document {}
  options =
    reducer: {
      location: location-actions
      entities: reduce-entities
    }
    initial-state: initial-state
    actions: setup-actions.concat actions
    init: init

  h store-provider, options,
    h sync-env, key: \sync-env, children

export default: stack-provider
