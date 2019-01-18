const babel = require('@babel/core')

const process = (src, path) => babel.transform(src, {
  filename: path,
  plugins: [].concat(
    require.resolve('@babel/plugin-transform-modules-commonjs'),
    require.resolve('babel-plugin-istanbul')
  ),
  sourceMaps: 'inline'
}).code

module.exports = {process}
