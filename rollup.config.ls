import
  \rollup-plugin-babel : babel
  \rollup-plugin-commonjs : commonjs
  \rollup-plugin-node-resolve : resolve

targets =
  * \src/app/index.ls \dist/index.esm.js \es
  * \src/build/index.ls \lib/index.js \cjs
  * \src/cli/index.ls \bin/index.js \cjs

config-list = targets.map ([input, output, format]) ->
  input: input
  output: file: output, format: format, sourcemap: true strict: false
  plugins:
    resolve jsnext: true extensions: <[.ls .js]>
    commonjs include: 'node_modules/core-js/**'
    babel!

  external: Object.keys <| require \./package.json .dependencies

export default: config-list