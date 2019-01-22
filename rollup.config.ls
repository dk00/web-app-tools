import
  'rollup-plugin-babel': babel
  'rollup-plugin-pnp-resolve': pnp-resolve

targets =
  * \src/app/index.ls \dist/index.esm.js \es
  * \src/build/index.ls \lib/index.js \cjs

externals = Object.keys <| require './package.json' .dependencies

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
    pnp-resolve!
    babel babel-options
  external: ->
    externals.includes it or it.includes '@babel/runtime'

export default: config-list
