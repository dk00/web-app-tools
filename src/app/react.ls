import preact: {h, render, Component}

function should-wrap => typeof it == \string || it::?render

function create-class spec
  ctor = (props) ->
    if spec.has-own-property \constructor then spec.constructor.call @, props
    else void
  ctor:: = Object.assign (Object.create Component::), spec, constructor: ctor
  Object.assign ctor, {spec.display-name}

function create-factory component
  if should-wrap component then ({children, ...props}) ->
    h component, props, children
  else component

export {h, render, Component, create-class, create-factory}
