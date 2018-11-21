import
  react: {
    use-state, use-reducer, use-context, use-effect
    use-memo, use-callback, use-ref
  }
  '../utils': {flat-diff}
  './react': {store-context}

function use-store => use-context store-context

function use-store-state selector, props
  store = use-context store-context
  own-props = use-ref!
  derived-state = use-ref!
  [, notify-update] = use-state!
  if flat-diff props, own-props.current
    own-props.current := props
    derived-state.current := selector store.get-state!, own-props.current

  #FIXME unmounted children should not get notified
  setup = -> store.subscribe ->
    prev = derived-state.current
    derived-state.current := selector store.get-state!, own-props.current
    if flat-diff prev, derived-state.current then notify-update!
  use-effect setup, []
  #TODO skip component update if derived state is unchanged
  derived-state.current

export {use-state, use-reducer, use-effect, use-ref, use-store, use-store-state}
export {use-context, use-memo, use-callback}
