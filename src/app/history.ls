import
  './collection': {update-model}
  '../utils': {parse-search}

function get-path data: app: location: {pathname} => pathname

function push-state env, path
  if path != env.location.pathname
    env.history.push-state {} '' path

function update-location {pathname, search=''}
  update-model id: \location values:
    {pathname, search: parse-search search}

function sync-history store, env
  store.subscribe ->
    push-state env, get-path store.get-state!
  env.add-event-listener \popstate ->
    store.dispatch update-location env.location

export {sync-history, update-location}
