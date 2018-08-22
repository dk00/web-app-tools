import '../src/build/webpack-config': webpack-config

function main t
  result = webpack-config! {}

  actual = result.mode
  expected = \development
  t.is actual, expected, 'development mode'

  result = webpack-config! p: true

  actual = result.mode
  expected = \production
  t.is actual, expected, 'production mode'


  result = webpack-config env: ['PATH'] <| {}

  actual = result.plugins.1.constructor.name
  expected = \EnvironmentPlugin
  t.is actual, expected, 'add environment variables'

  t.end!

export default: main