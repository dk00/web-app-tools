import
  './hooks': {use-effect}
  './store': {use-store, use-store-state}

function get-document {entities: {documents}} {type=\app id=\shared}={}
  documents[type]?[id]

function update-document {type, id, values}
  type: \update-document payload: {type, id, values}

function get-collection {entities={}} {type=\default name=type}
  {type, documents=[]} = entities.collections?[name] || {}
  by-id: entities.documents?[type]
  documents: documents

function replace-collection {type, name, documents}
  type: \replace-collection payload: {type, name, documents}

function add-to-end {type, name, documents}
  type: \add-to-end payload: {type, name, documents}

function add-to-start {type, name, documents}
  type: \add-to-start payload: {type, name, documents}

function remove-documents {type, name, documents}
  type: \remove-documents payload: {type, name, documents}

function use-shared-state name=\default initial-value
  {dispatch} = use-store!
  {value} = use-store-state (state) ->
    value: get-document state .[name]
  set-value = -> dispatch update-document values: (name): it

  use-effect !->
    if value == void && initial-value != void then set-value initial-value
  , []
  [value, set-value]

function merge-documents state={} {documents}
  Object.assign {} state, ...documents.map -> (it.id): it

reduce-documents =
  'update-document': (state={} {id=\shared values}) ->
    Object.assign {} state, (id): Object.assign {} state[id], values
  'replace-collection': merge-documents
  'add-to-end': merge-documents
  'add-to-start': merge-documents
  'remove-documents': -> it

reduce-collections =
  'replace-collection': (state, {type, name=type, documents}) ->
    Object.assign {} state, (name): {type, documents: documents.map (.id)}
  'add-to-end': (state={} {type, name=type, documents}) ->
    Object.assign {} state, (name): {
      type
      documents: (state[name]?documents || [])concat documents.map (.id)
    }
  'add-to-start': (state={} {type, name=type, documents}) ->
    Object.assign {} state, (name): {
      type
      documents: documents.map (.id) .concat state[name]?documents || []
    }
  'remove-documents': (state, {type, name=type, documents}) ->
    to-remove = Object.assign {} ...documents.map -> (it): 1
    Object.assign {} state, (name): {
      type,
      documents: (state[name]?documents || [])filter -> !to-remove[it]
    }

function get-type collections, {name}
  collections?[name]?type || \app

function initial-state => documents: {} collections: {}

function reduce-entities state=initial-state!, {type: action-type, payload}
  if action-type of reduce-documents
    {documents={} collections} = state
    {type=get-type collections, payload} = payload
    documents: Object.assign {} documents, (type):
      reduce-documents[action-type] documents[type], payload
    collections: reduce-collections[action-type]? collections, payload or collections
  else state

export {reduce-entities}
export {use-shared-state, get-document, get-collection}
export {update-document, replace-collection, add-to-end, add-to-start, remove-documents}
