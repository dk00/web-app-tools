import
  'rollup-plugin-babel': babel
  'rollup-plugin-node-resolve': node-resolve
  'rollup-plugin-pnp-resolve': pnp-resolve

targets =
  * \src/app/index.ls \dist/index.esm.js \es
  * \src/build/index.ls \lib/index.js \cjs

{dependencies, peer-dependencies} = require './package.json'

externals = Object.keys dependencies .concat Object.keys peer-dependencies

config-list = targets.map ([input, output, format]) ->
  transform-runtime =
    * require.resolve '@babel/plugin-transform-runtime'
      regenerator: false
      use-ES-modules: format == \es

  {presets, plugins} = require './.babelrc'
  babel-options =
    presets: presets
    plugins: plugins.concat [transform-runtime]
    runtime-helpers: true

  input: input
  output: file: output, format: format, sourcemap: true strict: false
  plugins:
    node-resolve extensions: ['.ls' '.jsx' '.js']
    pnp-resolve!
    babel babel-options
  external: ->
    externals.includes it or it.includes '@babel/runtime'

export default: config-list
