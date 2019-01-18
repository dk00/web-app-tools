import './react': {h, create-factory}

function pipe ...enhancers => (component) ->
  enhancers.reduce (component, enhance) -> enhance component
  , component

function compose ...enhancers => (component) ->
  enhancers.reduce-right (component, enhance) -> enhance component
  , component

function map-props map => (component) ->
  render = create-factory component
  map-props = (props) -> render map props
  if process.env.NODE_ENV != \production
    return with-display-name map-props, component, \map-props
  map-props

function with-props map => (component) ->
  enhance = map-props (props) -> Object.assign {} props, (map? props or map)
  with-props = enhance component
  if process.env.NODE_ENV != \production
    return with-display-name with-props, component, \with-props
  with-props

function default-props fallback => (component) ->
  render = create-factory component
  default-props = (props) -> render Object.assign {} fallback, props
  if process.env.NODE_ENV != \production
    return with-display-name default-props, component, \default-props
  default-props

function branch test, enhance-true, enhance-false=compose! => (component) ->
  render-true = render-false = void
  branch = (props) ->
    factory = if test props
      render-true or (render-true := create-factory enhance-true component)
    else
      render-false or (render-false := create-factory enhance-false component)
    factory props
  if process.env.NODE_ENV != \production
    return with-display-name branch, component, \branch
  branch

export {compose, pipe, branch, map-props, with-props, default-props}
