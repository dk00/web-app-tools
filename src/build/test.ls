import
  tape
  \./register : register

function test units, dirname
  register if process.argv.length > 2 then plugins: [\istanbul] else {}
  list = if process.argv.length > 2 then process.argv.slice 2
  else Object.keys units
  list.for-each (name) ->
    tape units[name] || name, (require "#dirname/#name" .default)

export default: test
