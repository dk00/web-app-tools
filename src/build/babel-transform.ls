import
  '@babel/core': {transform-sync}
  './babel-options': babel-options

function get-babel-options path
  cjs = require.resolve '@babel/plugin-transform-modules-commonjs'
  options = babel-options!
  Object.assign {} options,
    filename: path
    plugins: []concat options.plugins, cjs
    source-maps: \inline

function process src, path
  transform-sync src, get-babel-options path .code

transform = {process}

export default: transform
