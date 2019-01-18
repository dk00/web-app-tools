import
  '@babel/core': {transform-sync}
  './babel-options': babel-options

function get-babel-options path
  plugins =
    require.resolve '@babel/plugin-transform-modules-commonjs'
    require.resolve 'babel-plugin-istanbul'

  options = babel-options!
  Object.assign {} options,
    filename: path
    babelrc: false
    plugins: []concat options.plugins, plugins
    source-maps: \inline

function process src, path
  transform-sync src, get-babel-options path .code

transform = {process}

export default: transform
