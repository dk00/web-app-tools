import
  './dom': {add-event-listener}
  './collection': {update-model}

function try-parse
  try return JSON.parse it

function load-config {local-storage={}}
  try-parse local-storage.config

function initial-config env, {service}
  Object.assign {} service, load-config env

function sync-config store, {local-storage}: env
  last = void
  store.subscribe ->
    data = store.get-state!data.app.service
    if data != last
      local-storage.config = JSON.stringify last := data
  add-event-listener env, \storage ->
    store.dispatch update-model id: \service values: load-config env

export {sync-config, initial-config}
