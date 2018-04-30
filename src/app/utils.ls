function flat-diff a, b
  return false if a == b
  return true if typeof a != \object or typeof b != \object
  keys = Object.keys a
  return true if keys.length != Object.keys b .length
  keys.some -> a[it] != b[it]

function kebab-case
  it.replace /[a-z][A-Z]/, ([a, b]) -> "#{a}-#{b.to-lower-case!}"

function component-name
  name = it.display-name || it.name || it
  if name && \string == typeof name then name else \component

function with-display-name enhanced, base, modifier
  name = kebab-case component-name base
  enhanced.display-name = name + ':' + modifier
  enhanced

export {flat-diff, with-display-name}
