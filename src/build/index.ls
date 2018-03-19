import
  './webpack-config': webpack-config
  './rollup-config':  rollup-config
  './test': test

export {webpack-config, rollup-config, test}
export \../app/index : {
  start-app, h, create-class
  compose, with-context, with-state, map-props
  wrap-plugin, create-effect
  fetch-object, fetch-action
  handle-routes, parse-route
  core-js-workaround
}
