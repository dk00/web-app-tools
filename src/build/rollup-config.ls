import
  \./babel-options : babel-options

default-options = source-map: true

function rollup-config options
  css-url = require \postcss-url
  postcss = require \rollup-plugin-postcss
  babel = require \rollup-plugin-babel
  resolve = require \rollup-plugin-node-resolve
  replace = require \rollup-plugin-replace

  replacements =
    'module.hot': JSON.stringify false
    'process.env.NODE_ENV': JSON.stringify \production
  postcss-options = Object.assign {} default-options,
    extract: \./dist/index.css
    plugins: if options.css-url then [css-url url: options.css-url] else []

  input: \./src/index.js
  output: file: \./dist/index.js format: \iife sourcemap: true strict: false
  plugins:
    resolve jsnext: true extensions: <[.js .jsx .sass .scss]>
    postcss postcss-options
    babel babel-options options

export default: rollup-config
