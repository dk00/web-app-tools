import './collection': {update-model}

function get-path data: app: location: {pathname} => pathname

function push-state env, path
  if path != env.location.pathname
    env.history.push-state {} '' path

function sync-history store, env
  store.subscribe ->
    push-state env, get-path store.get-state!
  env.add-event-listener \popstate ->
    store.dispatch update-model id: \location values:
      pathname: env.location.pathname

export {sync-history}
