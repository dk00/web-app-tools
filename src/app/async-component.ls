import
  './with-display-name' : with-display-name
  './react': {h, create-class, create-factory}
  './hooks': {use-state, use-effect, use-ref}

function empty => ''

function async-component load-component, placeholder=empty
  async-component = (props) ->
    component = use-ref placeholder
    [loaded, set-loaded] = use-state false
    use-effect !-> load-component!then ->
      component.current := it.default
      set-loaded true
    , []
    h component.current, props, props.children

  if process.env.NODE_ENV != \production
    return with-display-name async-component, load-component, \async-component
  async-component

export default: async-component
