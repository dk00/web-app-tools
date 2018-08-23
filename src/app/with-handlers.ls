import
  \./react : {create-class, create-factory}
  '../utils': {map-values}
  \./with-display-name : with-display-name

function with-handlers handlers => (component) ->
  factory = create-factory component
  with-handlers = create-class do
    constructor: !->
      @handlers = map-values handlers, (create-handler) ~> (...args) ~>
        {dispatch, get-state} = @context.store
        handler = create-handler Object.assign {dispatch, get-state} @props
        handler ...args
    render: ->
      factory Object.assign {} @props, @handlers

  if process.env.NODE_ENV != \production
    return with-display-name with-handlers, component, \with-handlers
  with-handlers

export default: with-handlers
