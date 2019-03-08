module.exports = {
  presets: [
    require.resolve('babel-preset-upcoming')
  ],
  plugins: [
    require.resolve('babel-plugin-livescript')
  ].concat(
    process.env.NODE_ENV === 'test'?
      require.resolve('@babel/plugin-transform-modules-commonjs'): [],
    process.env.NODE_ENV === 'test'?
      require.resolve('babel-plugin-istanbul'): []
  ),
  sourceMaps: process.env.NODE_ENV === 'test'? 'inline': false
}
