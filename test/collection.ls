import
  \../src/app/actions : {handle-actions}
  \../src/app/collection : {
    update-collection, update-model
    reduce-collection, reduce-data
    collection-state, collection-props
  }

function selector t
  state =
    collection:
      dessert:
        model: \cart-item
        items: 'model id list'
    data:
      \cart-item : 'model cache'
      field: 'field cache'
  props = collection: \dessert
  result = collection-state state, props
  
  actual = result{items, data}
  expected = items: 'model id list' data: 'model cache'
  t.same actual, expected, 'get state of desired collection'

  actual = result{collection, model}
  expected = collection: \dessert model: \cart-item
  t.same actual, expected, 'get collection meta'

  actual = result.field
  expected = 'field cache'
  t.is actual, expected, 'include field data'

  state =
    collection: dessert: items: 'model id list'
    data: dessert: 'model cache'

  actual = collection-state state, props .model
  expected = \dessert
  t.same actual, expected, 'model path defaults to collection id'

  state = collection: {} data: {}

  actual = collection-state state, props .{items, data}
  expected = items: void data: void
  t.same actual, expected, 'getting collection from empty state'

  state =
    collection: \cart-items model: \dessert
    field: 
      * collection: \cart-items key: \name name: \Name
      * collection: \cart-items key: \id name: \Id
      * collection: \dummy
    items: [1 3]
    data:
      1: value: \pudding
      3: value: \candy
  result = collection-props state

  actual = result.models
  expected = [value: \pudding ; value: \candy]
  t.same actual, expected, 'bind values of collection list'

  actual = result{collection, model}
  expected = collection: \cart-items model: \dessert
  t.same actual, expected, 'pass collection meta'

  actual = result.fields
  expected =
    * collection: \cart-items key: \name name: \Name
    * collection: \cart-items key: \id name: \Id
  t.same actual, expected, 'pass fields for collection'

  actual = collection-props {}
  expected = collection: void model: void models: [] fields: []
  t.same actual, expected, 'binding collection list with empty state'

function main t
  r = handle-actions reduce-collection
  items =
    * id: 0 name: \a
    * id: 1 name: \b
  action = type: \update-collection payload:
    id: \t model: \cache, models: items
  state = t: [3]
  next-state = r state, action

  actual = next-state.t.model
  expected = \cache
  t.is actual, expected, 'replace data cache path of collection'

  actual = next-state.t.items
  expected = [0 1]
  t.same actual, expected, 'replace id list with fetched data'

  action = update-collection model: \new-collection models: items

  actual = r state, action .'new-collection'
  t.true actual, 'collection id defaults to model path'

  actual = reduce-collection\update-collection {} {}
  t.false actual, 'ignore actions w/o collection id'

  payload = id: \t models: []
  actual = \path of reduce-collection\update-collection {model: \original} payload
  t.false actual, 'keep path unchanged if not specified'

  actual = update-collection id: \collection model: \model models: [id: \id]
  expected = type: \update-collection payload:
    id: \collection model: \model models: [id: \id]
  t.same actual, expected, 'create action to update a collection'

  actual = update-model model: \model-path id: \id values: v: 1
  expected = type: \update-model payload:
    model: \model-path id: \id values: v: 1
  t.same actual, expected, 'create action to update a model'

  items =
    * id: 0 name: \a
    * id: 1 name: \b
  action = type: \update-collection payload: id: \t model: \t models: items
  reduce = handle-actions reduce-data
  state = t: existing: name: \existing
  merged = reduce state, action .t

  actual = merged.0
  expected = id: 0 name: \a
  t.same actual, expected, 'save fetched data'

  actual = merged.existing
  expected = name: \existing
  t.same actual, expected, 'keep existing data'

  state =
    app:
      location: \main
      \tab-index : \env-info : 1
  action = type: \update-model payload:
    model: \app id: \tab-index
    values: \env-info : 2

  actual = reduce state, action .app
  expected =
    location: \main
    \tab-index : id: \tab-index \env-info : 2
  t.same actual, expected, 'update 1 model values'

  actual = reduce {} action .app'tab-index'.'env-info'
  expected = 2
  t.same actual, expected, 'update values to not existing'

  state = app: location: pathname: \origin
  action = type: \update-model payload:
    id: \location values: pathname: 'default path'

  actual = reduce state, action ?.app?location?pathname
  expected = 'default path'
  t.same actual, expected, 'cache path defaults to app'

  selector t

  t.end!

export default: main
