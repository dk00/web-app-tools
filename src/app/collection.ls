function update-collection type=\replace-collection {id, model, models}
  {type, payload: {id, model, models: []concat models}}

function replace-collection options
  update-collection \replace-collection options

function unshift-collection options
  update-collection \unshift-collection options

function push-collection options
  update-collection \push-collection options

function update-model {model, id, values}
  type: \update-model payload: {model, id, values}

function clear-model options => type: \clear-model payload: options

function model-state {data} {model=\app id} => data[model]?[id]

function field-state state, {field=\value}: props
  value: model-state state, props ?.[field]
  own-props: props

function collection-state {collection: source, data} {collection, ...rest}
  {model=collection, items}? = source[collection]
  {collection, model, data.field, items, data: data[model], rest}

function collection-props {collection, model, field={} items=[] data, rest}
  fields = Object.values field .filter -> it.collection == collection
  Object.assign {collection, model, fields, models: items.map (data.)} rest

function merge-result state, {model=\app models}
  (model): Object.assign {} state[model], ...models.map -> (it.id): it

function handle-collection merge => (state, {id, model, models}) ->
  if !id then void else (id):
    Object.assign {} state[id],
      if model then {model}
      items: merge state[id]?items, models.map (.id)

function get-model {model} => model || \app

reduce-collection =
  'replace-collection': handle-collection (, added) -> added
  'unshift-collection': handle-collection (existing=[] added) ->
    []concat added, existing
  'push-collection': handle-collection (existing=[] added) ->
    []concat existing, added

reduce-data =
  'replace-collection': merge-result
  'unshift-collection': merge-result
  'push-collection': merge-result
  'clear-model': (state, {id}: payload) ->
    model = get-model payload
    merge-result state, {model, models: [{id}]}
  'update-model': (state, {id, values}: payload) ->
    model = get-model payload
    updated = Object.assign {id} state[model]?[id], values
    merge-result state, {model, models: [updated]}

export {
  replace-collection, push-collection, unshift-collection
  update-model, clear-model
  collection-state, collection-props
  model-state, field-state
  reduce-collection, reduce-data
}
