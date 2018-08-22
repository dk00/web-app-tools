import
  redux: {create-store}
  '../utils': {deep-merge}
  './actions': {compose-reduce}
  './collection': {reduce-collection: collection, reduce-data: data, update-model}
  './history': {update-location}
  './local-config': {initial-config}

function craft-reduce {reduce}
  compose-reduce Object.assign {collection, data} reduce

function initial-state {env, state={}}
  deep-merge state, collection: {} data: {}

function craft-store {env, actions=[]}: options
  reduce = craft-reduce options
  state = actions.concat do
    update-location env.location
    update-model id: \service values: initial-config env, options
  .reduce reduce, initial-state options
  create-store reduce, state, env?__REDUX_DEVTOOLS_EXTENSION__?!

export default: craft-store
