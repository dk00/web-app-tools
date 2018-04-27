function fetch-data {path, collection=path, items}
  type: \fetch payload: {path, collection, items: []concat items}

function merge-result state, {path, items}
  (path): Object.assign {} state[path], ...items.map -> (it.id): it

reduce =
  fetch: merge-result
  \update-data : (state, {path=\app id, values}) ->
    updated = Object.assign {id} state[path]?[id], values
    merge-result state, {path, items: [updated]}
  \toggle-value :  (state, {path=\app id, field, key=field}) ->
    prev = state[path]?[id] || {}
    result = Object.assign {id} prev, (key): !prev[key]
    merge-result state, {path, items: [result]}

export {reduce, fetch-data}
