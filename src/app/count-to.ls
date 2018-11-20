import
  './react': {h}
  './hooks': {use-state, use-effect, use-ref}

function step current, value, duration=16
  diff = value - current
  sign = Math.sign diff
  sign + Math.floor diff / duration

function count-to {class-name, class: name=class-name, value=0 inner-ref: ref}
  updating = use-ref!
  [current, set-value] = use-state 0
  use-effect !->
    delta = step current, if /active/test name then value else 0
    if !updating.current && delta != 0
      updating.current := true
      request-animation-frame ->
        set-value -> it + delta
        updating.current := false
    ->

  h \span {ref} current

export default: count-to
