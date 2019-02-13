import
  './react' : {h, create-factory}
  './collection' : {update-model}
  './input': {field-props, input-props, model-options}

function render-field {type, class: styles, class-name=styles, value, on-change, children}
  attributes = Object.assign {value, class-name} if on-change
    on-change: (target: {value}) -> on-change value
  if type == \input then h type, attributes
  else h type, attributes, children

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
