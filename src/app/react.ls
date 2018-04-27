import preact: {h, render, Component}

function is-class => it::?render

function create-class spec
  ctor = (props) ->
    if \constructor of spec then spec.constructor.call @, props
  ctor:: = Object.assign (Object.create Component::), spec, constructor: ctor
  Object.assign ctor, {spec.display-name}

function create-factory component
  if is-class component then -> h component, it
  else component

export {h, render, Component, create-class, create-factory}
