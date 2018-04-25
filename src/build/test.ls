import
  tape
  path: {join}
  \./register : register

function test units, path=\test
  prefix = join process.cwd!, path
  list = if process.argv.length > 2 then process.argv.slice 2
  register if list then {} else plugins: [\istanbul]
  (list || Object.keys units)for-each (name) ->
    tape units[name] || name, (require join prefix, name .default)

export default: test
