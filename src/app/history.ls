import
  './collection': {replace-collection}
  '../utils': {parse-search, query-string}

function get-path data: app: {location: {pathname, hash=''} search: {id, ...search}}
  query = if query-string search then '?' + that else ''
  pathname + query + hash

function scroll-to-anchor {location: {hash} document}
  hash and document.query-selector hash ?.scroll-into-view behavior: \smooth

function push-state {location, history}: env, path
  if path != location.pathname + location.search + location.hash
    history.push-state {} '' path
    scroll-to-anchor env

function update-location {pathname, search='' hash}
  replace-collection model: \app models:
    * {id: \location pathname, hash}
    * Object.assign id: \search, parse-search search

function sync-history store, env
  store.subscribe ->
    push-state env, get-path store.get-state!
  env.add-event-listener \popstate ->
    store.dispatch update-location env.location

export {sync-history, update-location}
