import '../utils': {exclude}

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

function remove-models {id, model, models}
  type: \remove-models payload: {id, model, models}

function model-state {data} {model=\app id} => data[model]?[id]

function field-state state, {field=\value}: props
  value: model-state state, props ?.[field]
  own-props: props

function list-state {collection: source, data} {requests=[], collection=requests.0.collection, ...rest}
  {model, items}? = source[collection]
  {items, collection, model, rest}

function selector-model {rest, collection, model=rest.model || collection}
  model

function list-props {items, rest, collection, dispatch}: state
  Object.assign {} rest,
    {dispatch, items: items || [], loaded: items, collection, model: selector-model state}

function collection-state {data}: state, props
  result = list-state state, props
  Object.assign {data: data[result.model], data.field} result

function collection-props {collection, field={} items=[] data, rest}: state
  model = selector-model state
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
  'remove-models': (state, {id, models}) ->
    if state[id]
      (id): Object.assign {} state[id], items: exclude state[id]items, models
    else {}

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
  'remove-models': (state, {id, model=id, models}) ->
    data = state[model]
    if data
      entries = exclude (Object.keys data), models .map -> (it): data[it]
      (model): Object.assign {} ...entries
    else {}

export {
  replace-collection, push-collection, unshift-collection
  update-model, clear-model, remove-models
  list-state, list-props, collection-state, collection-props
  model-state, field-state
  reduce-collection, reduce-data
}
