import
  './collection': {replace-collection}
  './dom': {add-event-listener}
  '../utils': {parse-search, query-string}

function get-path data: app: {location: {pathname, hash=''} search: {id, ...search}}
  query = if query-string search then '?' + that else ''
  pathname + query + hash

function push-state {location, history}: env, path
  if path != location.pathname + location.search + location.hash
    history.push-state {} '' path

function update-location {pathname, search='' hash}
  replace-collection model: \app models:
    * {id: \location pathname, hash}
    * Object.assign id: \search, parse-search search

function sync-location store, env
  un =
    store.subscribe ->
      push-state env, get-path store.get-state!
    add-event-listener env, \popstate ->
      store.dispatch update-location env.location
  -> un.for-each -> it!

export {sync-location, update-location}
