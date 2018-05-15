import
  \./react : {h}
  \./recompose : {compose, with-state, map-props}
  \./sync : {api-url}
  \./collection : {
    update-model, update-collection
    collection-state, collection-props, field-state
  }
  \./create-effect : create-effect
  \./fetch-object : fetch-object

function with-collection collection
  compose do
    with-state collection-state collection
    map-props collection-props

function input-actions dispatch, {model, id, field=\value}
  on-change: ->
    dispatch update-model {model, id, values: (field): it}

function input-props {value, {type, children}: original-props, dispatch}
  Object.assign {value, type, children},
    input-actions dispatch, original-props

link-field = compose do
  with-state field-state
  map-props input-props

function render-field {type, value, on-change, children}
  attributes =
    value: value
    on-change: (target: {value}) -> on-change value
  h type, attributes, children

linked-input = link-field render-field

function toggle-props {on-change, ...props}
  on-click = -> on-change target: value: !props.value
  Object.assign {} props, {on-click} if props.value then class: \active

wrap-toggle = map-props toggle-props

function toggle props
  attributes = Object.assign {} props, type: wrap-toggle props.type
  h linked-input, attributes, props.children

function fetch-resource {collection, parameters} context
  url = api-url context, collection
  fetch-object url, {parameters} .then ->
    options = id: collection, model: collection, models: it
    context.store.dispatch update-collection options

require-data = create-effect fetch-resource

export {with-collection, linked-input, toggle, require-data}
