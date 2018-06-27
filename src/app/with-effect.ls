import
  \./with-display-name : with-display-name
  './react': {create-class, create-factory}

function handle-changes instances, apply-effects
  apply-effects (instances.map (.props)), instances.0?context

function with-effect apply-effects => (component) ->
  instances = []
  render-child = create-factory component
  hooks =
    component-did-mount: ->
      instances := instances.concat @
      handle-changes instances, apply-effects
    component-did-update: ->
      handle-changes instances, apply-effects
    component-will-unmount: ->
      instances := instances.filter (!= @)
      handle-changes instances, apply-effects
    render: -> render-child @props

  enhanced = create-class hooks
  if process.env.NODE_ENV != \production
    return with-display-name enhanced, component, \with-effect
  enhanced

export default: with-effect
