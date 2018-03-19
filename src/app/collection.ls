reduce =
  fetch: (state, {collection, path, items}) ->
    if collection then (collection):
      Object.assign {}, state[collection],
        if path then path: path
        items: items.map (.id)

export {reduce}
