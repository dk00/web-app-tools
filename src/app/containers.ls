import
  \./react : {h, create-factory}
  \./recompose : {pipe, compose, with-state, map-props, with-props, branch}
  \./collection : {
    update-model
    collection-state, collection-props, field-state
    list-state, list-props
  }
  './input': {field-props, input-props, have-options, select-source, model-options}
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

with-list-data = compose do
  with-api-data
  with-state list-state
  map-props list-props

link-field = compose do
  with-state field-state
  map-props input-props

function render-field {type, class: styles, class-name=styles, value, on-change, children}
  attributes = Object.assign {value, class-name} if on-change
    on-change: (target: {value}) -> on-change value
  if type == \input then h type, attributes
  else h type, attributes, children

linked-input = link-field render-field

with-select-options = branch have-options, compose do
  map-props select-source
  with-collection
  with-props model-options

function wrap-toggle-handler {on-change, ...props} {propagate}
  if on-change
    Object.assign {} props, on-click: ->
      it.stop-propagation! if !propagate
      on-change target: value: !props.value
  else props

function add-active-class {value, ...props}
  if !value then props
  else
    existing = if props.class-name || props.class then that + ' ' else ''
    Object.assign {} props, class-name: "#{existing}active"

function toggle-props props, outer-props
  add-active-class wrap-toggle-handler props, outer-props

function wrap-toggle props
  factory = create-factory props.type
  Object.assign {} props, type: (inner-props) ->
    factory toggle-props inner-props, props

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
  with-list-data, with-collection, with-api-data, with-select-options
  linked-input, toggle, toggle-target
}
