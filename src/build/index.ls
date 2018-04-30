import
  './webpack-config': webpack-config
  './rollup-config':  rollup-config
  './test': test

export {webpack-config, rollup-config, test}
export \../app/index : {
  start-app, h, create-class
  with-state, map-props, compose, with-context
  wrap-plugin, create-effect
  route, nav-link
  fetch-object, fetch-action
  core-js-workaround
}
