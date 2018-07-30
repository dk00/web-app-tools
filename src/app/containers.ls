import
  \./react : {h, create-factory}
  \./recompose : {pipe, compose, with-state, map-props}
  \./collection : {
    update-model
    collection-state, collection-props, field-state
  }
  './input': {field-props, input-props}
  \./with-fetch : with-fetch
  \./requests : {result-message}

fetch-options =
  handle-error: -> console.log it
  handle-result: (result, request) ->
    post-message (result-message result, request), \*

with-api-data = with-fetch fetch-options

with-collection = compose do
  with-api-data
  with-state collection-state
  map-props collection-props

function const-options data: {select}, {field}
  data: select[field]

function options-model {data}
  options: Object.entries data .map ([value, label]) ->
    {value, label}

with-constant-options = compose do
  with-state const-options
  map-props options-model

function with-select-options
  with-constant-options it

link-field = compose do
  with-state field-state
  map-props input-props

function render-field {type, class: class-name, value, on-change, children}
  attributes = Object.assign {value, class: class-name} if on-change
    on-change: (target: {value}) -> on-change value
  h type, attributes, children

linked-input = link-field render-field

function wrap-toggle-handler {on-change, ...props}: q
  if on-change
    Object.assign {} props, on-click: -> on-change target: value: !props.value
  else props

function add-active-class {value, ...props}
  if !value then props
  else
    existing = if props.class then that + ' ' else ''
    Object.assign {} props, class: "#{existing}active"

function toggle-props props
  add-active-class wrap-toggle-handler props

function wrap-toggle props
  Object.assign {} props, type:
    pipe toggle-props, create-factory props.type

toggle = compose do
  map-props wrap-toggle
  link-field
<| render-field

toggle-target = compose do
  map-props wrap-toggle
  with-state field-state
  map-props field-props
<| render-field

if process.env.NODE_ENV != \production
  linked-input.display-name = \linked-input
  toggle.display-name = \toggle
  toggle-target.display-name = \toggle-target

export {
  with-collection, with-api-data, with-select-options
  linked-input, toggle, toggle-target
}
