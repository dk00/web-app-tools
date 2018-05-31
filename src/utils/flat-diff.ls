function flat-diff a, b
  return false if a == b
  return true if typeof a != \object or typeof b != \object
  keys = Object.keys a
  return true if keys.length != Object.keys b .length
  keys.some -> a[it] != b[it]

export default: flat-diff
