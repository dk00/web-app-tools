import '../src/build/webpack-config': webpack-config

function main t
  result = webpack-config! {}

  actual = result.mode
  expected = \development
  t.is actual, expected, 'development mode'

  tmp = process.env.NODE_ENV
  process.env.NODE_ENV = \production
  result = webpack-config!!
  process.env.NODE_ENV = tmp

  actual = result.mode
  expected = \production
  t.is actual, expected, 'production mode'

  result = webpack-config env: ['PATH'] <| {}

  actual = result.plugins.some -> it.constructor.name == \EnvironmentPlugin
  t.ok actual, 'add environment variables'

  t.end!

export default: main
