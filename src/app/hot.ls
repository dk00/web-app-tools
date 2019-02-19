import
  './react': {h}
  './hooks': {use-state, use-effect}

function hot app, init
  if module.hot && init then (props) ->
    [config, set-config] = use-state {app}
    use-effect (-> init (app) -> set-config {app}), []
    return h config.app, props
  else app

export default: hot
