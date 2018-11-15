import
  '../utils': {with-active-class, map-attributes}
  './dom': {on-visibility-change, above-view}
  './react': {h}
  './hooks': {use-state, use-effect, use-ref}

function active-above {type=\div children, ...props}
  element = use-ref!
  [above, set-above] = use-state false
  use-effect !-> on-visibility-change (env) ->
    next = if element.current
      above-view element.current, Object.assign {} env, props
    else above
    if above != next then set-above next
  , []

  final-props = Object.assign ref: element, inner-ref: element,
    if above then with-active-class props else map-attributes props
  h type, final-props, children

export default: active-above
