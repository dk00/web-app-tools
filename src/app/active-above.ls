import
  '../utils': {with-active-class}
  './dom': {on-visibility-change, above-view}
  './react': {h, create-class}

hooks =
  display-name: \active-above
  component-did-mount: ->
    @component-will-unmount = on-visibility-change (env) ~>
      above = above-view @element, Object.assign {} env, @props
      if above != @state.above then @set-state {above}
  render: ->
    ref = ~> @element := it
    init = if typeof @props.type == \function
      set-ref: ref
    else {ref}
    {type=\div children, ...props} = Object.assign {} init,
      if @state?above then with-active-class @props else @props
    h type, props, children

active-above = create-class hooks

export default: active-above
