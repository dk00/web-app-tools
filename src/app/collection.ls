function update-collection {id, model, models}
  type: \update-collection payload: {id, model, models: []concat models}

function update-model {model, id, values}
  type: \update-model payload: {model, id, values}

function model-state {data} {model=\app id} => data[model]?[id]

function field-state state, {field=\value}: props
  value: model-state state, props ?.[field]
  original-props: props

function collection-state {collection: source, data} {collection, ...rest}
  {model=collection, items}? = source[collection]
  {collection, model, data.field, items, data: data[model], rest}

function collection-props {collection, model, field={} items=[] data, rest}
  fields = Object.values field .filter -> it.collection == collection
  Object.assign {collection, model, fields, models: items.map (data.)} rest

function merge-result state, {model, models}
  (model): Object.assign {} state[model], ...models.map -> (it.id): it

reduce-collection =
  \update-collection : (state, {model, id=model, models}) ->
    if id then (id):
      Object.assign {} state[id],
        if model then {model}
        items: models.map (.id)

reduce-data =
  \update-collection : merge-result
  \update-model : (state, {model=\app id, values}) ->
    updated = Object.assign {id} state[model]?[id], values
    merge-result state, {model, models: [updated]}

export {
  update-collection, update-model
  collection-state, collection-props
  model-state, field-state
  reduce-collection, reduce-data
}
