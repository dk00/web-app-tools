import './react': {h, render}

function start-app app, {el='#root'}={}
  container = document.query-selector el
  mount = window.render || render
  mount (h app), container

  if !module.hot
    global.navigator.service-worker?register '/service-worker.js'

export default: start-app
