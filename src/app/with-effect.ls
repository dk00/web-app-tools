import
  \./with-display-name : with-display-name
  './react': {create-class, create-factory}

function handle-changes instances, merge-props, apply-effects
  apply-effects merge-props instances.map (.props)

function with-effect merge-props, apply-effects => (component) ->
  instances = []
  render-child = create-factory component
  hooks =
    component-did-mount: ->
      instances := instances.concat @
      handle-changes instances, merge-props, apply-effects
    component-did-update: ->
      handle-changes instances, merge-props, apply-effects
    component-will-unmount: ->
      instances := instances.filter (!= @)
      handle-changes instances, merge-props, apply-effects
    render: -> render-child @props

  enhanced = create-class hooks
  if process.env.NODE_ENV != \production
    return with-display-name enhanced, component, \with-effect
  enhanced

export default: with-effect
