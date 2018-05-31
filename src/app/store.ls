import
  redux: {create-store}
  \../utils : {deep-merge}
  \./actions : {compose-reduce}
  \./collection : {reduce-collection: collection, reduce-data: data}

function craft-reduce {reduce}
  compose-reduce Object.assign {collection, data} reduce

function initial-state reduce, {env, state={}}
  deep-merge state,
    collection: {}
    data:
      app: location: env.location{pathname}

function craft-store {env}: options
  reduce = craft-reduce options
  state = initial-state reduce, options
  create-store reduce, state, env?__REDUX_DEVTOOLS_EXTENSION__?!

export default: craft-store
