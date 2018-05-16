import
  \./react : {create-class, create-factory}
  \./utils : {with-display-name}
  \./with-state : with-state

function pipe ...enhancers => (component) ->
  enhancers.reduce (component, enhance) -> enhance component
  , component

function compose ...enhancers => (component) ->
  enhancers.reduce-right (component, enhance) -> enhance component
  , component

function map-props map => (component) ->
  render = create-factory component
  enhanced = (props) -> render map props
  if process.env.NODE_ENV != \production
    return with-display-name enhanced, component, \map-props
  enhanced

function with-context context => (component) ->
  hooks =
    get-child-context: -> context
    render: create-factory component
  enhanced = create-class hooks
  if process.env.NODE_ENV != \production
    return with-display-name enhanced, component, \with-context
  enhanced

function select-with-props selector => (state, props) ->
  Object.assign {} (select state), own-props: props

export {compose, pipe, with-context, with-state, map-props}
