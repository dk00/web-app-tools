import
  \./react : {create-class, create-factory}
  \./with-state : with-state

function compose ...enhancers => (component) ->
  enhancers.reduce-right (component, enhance) -> enhance component
  , component

function map-props map => (component) ->
  render = create-factory component
  (props) -> render map props

function with-context context => (render) ->
  hooks =
    get-child-context: -> context
    render: create-factory render
  create-class hooks

export {compose, with-context, with-state, map-props}
