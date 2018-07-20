import '../src/app/data-grid': {grid-state}

function sample-state
  collection:
    meta: items: [\a \b]
    ingredient: items: [1 2]
  data:
    meta:
      a: collection: \ingredient name: \Id field: \id
      b: collection: \ingredient name: \Name field: \name
    ingredient:
      1: id: 1 name: \sugar
      2: id: 2 name: \milk

function main t
  state = sample
  props = collection: \ingredient

  actuel = grid-state state, props
  expected = meta-items

  t.end!

export default main