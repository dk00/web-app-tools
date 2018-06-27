import
  \./react : {h, create-factory}
  \./recompose : {pipe, compose, with-state, map-props}
  \./collection : {
    update-model, update-collection
    collection-state, collection-props, field-state
  }
  \./create-effect : create-effect

function with-collection collection
  compose do
    with-state collection-state collection
    map-props collection-props

function input-actions dispatch, {model, id, field=\value}
  on-change: ->
    dispatch update-model {model, id, values: (field): it}

function field-props {value, original-props: {type, children, class: class-name}}
  {value, type, children, class: class-name}

function input-props {original-props, dispatch}: state
  Object.assign {},
    field-props state
    input-actions dispatch, original-props

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

export {with-collection, linked-input, toggle, toggle-target}
