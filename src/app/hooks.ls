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
  get-next = -> selector store.get-state!, props
  derived-state = use-ref get-next!
  [, notify-update] = use-state!
  #FIXME unmounted children should not get notified
  setup = -> store.subscribe ->
    next = get-next!
    if flat-diff next, derived-state.current
      derived-state.current := next
      notify-update!
  use-effect setup, []
  derived-state.current

export {use-state, use-effect, use-ref, use-context, use-store, use-store-state}
export {use-memo, use-callback}
