import
  \../src/app/actions : {handle-actions}
  \../src/app/collection : reduce: reduce-collection

function main t
  items =
    * id: 0 name: \a
    * id: 1 name: \b
  action = type: \fetch payload: {collection: \t path: \cache, items}
  state = t: [3]
  r = handle-actions reduce-collection

  next-state = r state, action

  actual = next-state.t.path
  expected = \cache
  t.is actual, expected, 'replace data cache path of collection'

  actual = next-state.t.items
  expected = [0 1]
  t.same actual, expected, 'replace id list with fetched data'

  actual = reduce-collection.fetch {} {}
  t.false actual, 'ignore actions w/o collection id'

  payload = collection: \t items: []
  actual = \path of reduce-collection.fetch {path: \original} payload
  t.false actual, 'keep path unchanged if not specified'

  t.end!

export default: main
