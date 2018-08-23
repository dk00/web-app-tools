function map-values source, map
  items = Object.entries source .map ([key, value]) ->
    (key): map value
  Object.assign ...items

export default: map-values
