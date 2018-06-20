units =
  utils: \Utilities
  history: 'Sync with Browser History'
  react: 'Wrapped React API'
  containers: \Containers
  collection: \Collection
  routing: \Routing
  sync: 'Sync app state with resources'
  'with-effect': 'Map nested component props changes to global effects'

function test units, path=\test
  {join} = require \path
  tape = require \tape
  register = require \../register
  prefix = join process.cwd!, path
  list = if process.argv.length > 2 then process.argv.slice 2
  register if list then {} else plugins: [\istanbul]
  (list || Object.keys units)for-each (name) ->
    tape units[name] || name, (require join prefix, name .default)

test units
