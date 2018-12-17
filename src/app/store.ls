import
  redux: {create-store}
  '../utils': {deep-merge}
  './actions': {compose-reduce}
  './collection': {reduce-collection: collection, reduce-data: data, update-model}
  './history': {update-location}
  './local-config': {initial-config}

function craft-reduce {reduce}
  compose-reduce Object.assign {collection, data} reduce

function craft-store {env, state, actions=[]}: options
  reduce = craft-reduce options
  initial-state = deep-merge state, collection: {} data: {}
  initial-actions =
    update-location env.location
    update-model id: \service values: initial-config env, options
  state = initial-actions.concat actions .reduce reduce, initial-state
  create-store reduce, state, env?__REDUX_DEVTOOLS_EXTENSION__?!

export {craft-store, craft-reduce}
