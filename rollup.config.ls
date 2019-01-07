import
  'rollup-plugin-babel': babel
  'rollup-plugin-pnp-resolve': pnp-resolve


targets =
  * \src/app/index.ls \dist/index.esm.js \es
  * \src/build/index.ls \lib/index.js \cjs

config-list = targets.map ([input, output, format]) ->
  input: input
  output: file: output, format: format, sourcemap: true strict: false
  plugins:
    pnp-resolve!
    babel require './.babelrc'

  external: Object.keys <| require \./package.json .dependencies

export default: config-list
