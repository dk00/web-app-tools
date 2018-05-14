function update-collection {id, model, models}
  type: \update-collection payload: {id, model, models: []concat models}

function update-model {model, id, values}
  type: \update-model payload: {model, id, values}

function get-values {data} {model=\app id} => data[model]?[id]

function field-state state, {field=\value}: props
  value: get-values state, props ?.[field]
  original-props: props

function collection-state id => ({collection, data}) ->
  {model=id, items}? = collection[id]
  {items, data: data[model]}

function collection-props {items=[] data}
  models: items.map (data.)

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
  field-state
  reduce-collection, reduce-data
}
