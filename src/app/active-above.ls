import
  '../utils': {with-active-class, map-attributes}
  './dom': {on-visibility-change, above-view}
  './react': {h}
  './hooks': {use-state, use-effect, use-ref}

function pass-ref ref, type
  if typeof type == \string then {ref} else inner-ref: ref

function active-above {type=\div children, ...props}
  element = use-ref!
  state = use-ref!
  [above, set-above] = use-state false
  state.current = above
  use-effect (-> on-visibility-change (env) ->
    next = if element.current
      above-view element.current, Object.assign {} env, props
    else state.current
    if state.current != next then set-above next
  ), []

  final-props = Object.assign {},
    pass-ref element, type
    if above then with-active-class props else map-attributes props
  h type, final-props, children

export default: active-above
