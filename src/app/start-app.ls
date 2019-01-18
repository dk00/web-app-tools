import
  './react': {h, render}
  './hooks': {use-state, use-effect}

function enable-replacement app, init
  if module.hot then (props) ->
    [config, set-config] = use-state {app}
    use-effect (-> init? (app) -> set-config {app}), []
    return h config.app, props
  else app

function start-app app, {el='#root' init}
  container = document.query-selector el
  mount = window.render || render
  mount (h enable-replacement app, init), container

  if !module.hot
    global.navigator.service-worker?register '/service-worker.js'

export default: start-app
