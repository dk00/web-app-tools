import
  './react': {h, create-factory}
  './hooks': {use-effect, use-ref, use-store}
  './with-display-name': with-display-name

function handle-changes instances, apply-effects
  apply-effects (instances.map (.props)), instances.0?context

function with-effect apply-effects
  instances = []
  (component) ->
    render-nested = create-factory component
    with-effect = (props) ->
      context = store: use-store!
      me = use-ref {}
      me.current := {props, context}
      use-effect ->
        instances.push me
        -> instances := instances.filter (!= me)
      , []
      use-effect !->
        handle-changes (instances.map -> it.current), apply-effects
      render-nested props

    if process.env.NODE_ENV != \production
      return with-display-name with-effect, component, \with-effect
    (props) -> h with-effect, props, props.children

export default: with-effect
