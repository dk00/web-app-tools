import
  '../utils': {flat-diff}
  './hooks': {use-store, use-store-state}
  './react': {h, create-factory}
  './with-display-name': with-display-name

function with-state selector => (maybe-render) ->
  render = create-factory maybe-render
  with-state = (props) ->
    {dispatch} = use-store!
    state-props = use-store-state selector, props
    render Object.assign {} state-props, {dispatch}
  if process.env.NODE_ENV != \production
    return with-display-name with-state, maybe-render, \with-state
  (props) -> h with-state, props, props.children

export default: with-state
