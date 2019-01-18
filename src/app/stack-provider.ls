import
  './react': {h}
  './hooks': {use-effect}
  './store': {store-provider, use-store, use-store-state}
  './routing': {location-actions, navigate}

default-URL = 'http://localhost'

function sync-env
  store = use-store!
  use-effect (!->
    window.add-event-listener \popstate ->
      store.dispatch navigate window.location
  ), []
  {href} = use-store-state ->
    Object.assign (new URL window.location), it.location .{href}
  use-effect (!->
    history.push-state {} '' href
  ), [href]
  ''

function stack-provider {reducer={} initial-state={} actions=[] init, children}
  options =
    reducer: {
      location: location-actions
    }
    initial-state: initial-state
    actions: []concat navigate window.location .concat actions
    init: init
    children: [h sync-env].concat children

  store-provider options

export default: stack-provider
