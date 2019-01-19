import
  react: {create-element: h, Fragment, create-context, memo}
  'react-dom': {render}

import react: {Component}

function should-wrap => typeof it == \string || it.hooks || it::?render

function create-class spec
  ctor = if spec.has-own-property \constructor
    (props) -> spec.constructor.call @, props
  else ->
  ctor:: = Object.assign (Object.create Component::), spec, constructor: ctor
  Object.assign ctor, {spec.display-name}

function create-factory component
  if should-wrap component then ({children, ...props}) ->
    h component, props, children
  else component

export {create-class, create-factory}
export {h, fragment: Fragment, render, create-context, memo}
