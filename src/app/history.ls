import
  './collection': {replace-collection}
  '../utils': {parse-search, query-string}

function get-path data: app: {location: {pathname} search: {id, ...search}}
  pathname + if query-string search then '?' + that else ''

function push-state {location, history} path
  if path != location.pathname + location.search
    history.push-state {} '' path

function update-location {pathname, search=''}
  replace-collection model: \app models:
    * id: \location pathname
    * Object.assign id: \search, parse-search search

function sync-history store, env
  store.subscribe ->
    push-state env, get-path store.get-state!
  env.add-event-listener \popstate ->
    store.dispatch update-location env.location

export {sync-history, update-location}
