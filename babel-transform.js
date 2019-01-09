const babel = require('@babel/core')

const getBabelOptions = () => {
  const options = require('./.babelrc.js')
  return Object.assign({}, options, {
    plugins: [].concat(
      options.plugins,
      require.resolve('@babel/plugin-transform-modules-commonjs')
    ),
    sourceMaps: 'inline'
  })
}

const options = getBabelOptions()

const process = (src, path) => babel.transform(
  src,
  Object.assign({filename: path}, options)
).code

module.exports = {process}
