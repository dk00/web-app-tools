import
  './hooks': {use-effect}
  './store': {use-store, use-store-state}

function get-document {entities} {model=\app id=\shared}={}
  entities[model]by-id[id]

function update-document {model, id, values}
  type: \update-document payload: {model, id, values}

function assign source, key, values
  {...source, (key): {...source[key], ...values}}

empty-entity = by-id: {} default: []

entity-actions =
  'update-document': ({by-id} {id=\shared, values}) ->
    by-id: assign by-id, id, values

function use-shared-state name=\default initial-value
  {dispatch} = use-store!
  {value} = use-store-state (state) ->
    value: get-document state .[name]
  set-value = -> dispatch update-document values: (name): it

  use-effect !->
    if value == void
      set-value initial-value
  , []
  [value, set-value]

function reduce-entities state={} {type, payload}
  if type of entity-actions
    {model=\app} = payload
    entity = state[model] || empty-entity
    assign state, model, entity-actions[type] entity, payload
  else state

export {reduce-entities}
export {use-shared-state, get-document}
export {update-document}
