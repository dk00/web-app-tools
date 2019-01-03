import
  react: {
    use-state, use-reducer, use-context, use-effect
    use-memo, use-callback, use-ref
  }
  '../utils': {flat-diff, identity}
  './react': {store-context}

function use-store => use-context store-context

function use-store-state selector, props
  store = use-context store-context
  own-props = use-ref use-store
  derived-state = use-ref!
  [, notify-update] = use-state!
  if flat-diff props, own-props.current
    own-props.current := props
    derived-state.current := selector store.get-state!, own-props.current
  setup = ->
    handle-changes = ->
      prev = derived-state.current
      derived-state.current := selector store.get-state!, own-props.current
      if flat-diff prev, derived-state.current then notify-update!
    un = store.subscribe handle-changes
    ->
      handle-changes := identity
      un!
  use-effect setup, []
  {store.dispatch, ...derived-state.current}

export {use-state, use-reducer, use-effect, use-ref, use-store, use-store-state}
export {use-context, use-memo, use-callback}
