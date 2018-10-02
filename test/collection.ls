import
  \../src/app/actions : {handle-actions}
  \../src/app/collection : {
    replace-collection, unshift-collection, push-collection
    update-model, clear-model
    reduce-collection, reduce-data
    collection-state, collection-props
    list-props
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
  props = collection: \dessert others: \should-be-passed
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

  actual = result.rest
  expected = others: \should-be-passed
  t.same actual, expected, 'other props should be passed'

  state = collection: \dessert rest: {}

  actual = collection-props state .model
  expected = \dessert
  t.is actual, expected, 'model path defaults to collection id'

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
    rest: others: 'should be added'
  result = collection-props state

  actual = result.models
  expected = [value: \pudding ; value: \candy]
  t.same actual, expected, 'bind values of collection list'

  actual = result{collection, model}
  expected = collection: \cart-items model: \dessert
  t.same actual, expected, 'pass collection meta'

  actual = result.others
  expected = 'should be added'
  t.is actual, expected, 'other props should be added'

  actual = result.fields
  expected =
    * collection: \cart-items key: \name name: \Name
    * collection: \cart-items key: \id name: \Id
  t.same actual, expected, 'pass fields for collection'

  actual = collection-props rest: {}
  expected = collection: void model: void models: [] fields: []
  t.same actual, expected, 'binding collection list with empty state'

function actions t
  options = id: \collection model: \model models: [id: \id]

  actual = replace-collection options
  expected = type: \replace-collection payload:
    id: \collection model: \model models: [id: \id]
  t.same actual, expected, 'create action to replace a collection'

  actual = unshift-collection options
  expected = type: \unshift-collection payload:
    id: \collection model: \model models: [id: \id]
  t.same actual, expected, 'create action to add to start of a collection'

  actual = push-collection options
  expected = type: \push-collection payload:
    id: \collection model: \model models: [id: \id]
  t.same actual, expected, 'create action to add to end of a collection'

  actual = update-model model: \model-path id: \id values: v: 1
  expected = type: \update-model payload:
    model: \model-path id: \id values: v: 1
  t.same actual, expected, 'create action to update a model'

  actual = clear-model model: \model-path id: \id
  expected = type: \clear-model payload: model: \model-path id: \id
  t.same actual, expected, 'create action to clear a model'

function collections t
  r = handle-actions reduce-collection
  items =
    * id: 0 name: \a
    * id: 1 name: \b
  action = type: \replace-collection payload:
    id: \t model: \cache, models: items
  state = t: items: [3]
  next-state = r state, action

  actual = next-state.t.model
  expected = \cache
  t.is actual, expected, 'replace data cache path of collection'

  actual = next-state.t.items
  expected = [0 1]
  t.same actual, expected, 'replace id list with fetched data'

  action = replace-collection model: \new-collection models: items

  actual = r state, action .'new-collection'
  t.false actual, 'collection is not updated if id is not specified'

  actual = reduce-collection\replace-collection {} {}
  t.false actual, 'ignore actions w/o collection id'

  payload = id: \t models: []
  actual = \path of reduce-collection\replace-collection {model: \original} payload
  t.false actual, 'keep path unchanged if not specified'

  action = type: \unshift-collection payload:
    id: \t model: \cache, models: items
  next-state = r state, action

  actual = next-state.t.items.join ' '
  expected = '0 1 3'
  t.is actual, expected, 'add to start of a collection'

  action = type: \push-collection payload:
    id: \t model: \cache, models: items
  next-state = r state, action

  actual = next-state.t.items.join ' '
  expected = '3 0 1'
  t.is actual, expected, 'add to start of a collection'

  actual = list-props items: [] rest: {} .loaded
  t.ok actual, 'add loaded state to list props'

function cache t
  items =
    * id: 0 name: \a
    * id: 1 name: \b
  action = type: \replace-collection payload: id: \t model: \t models: items
  reduce = handle-actions reduce-data
  state = t: existing: name: \existing
  merged = reduce state, action .t

  actual = merged.0
  expected = id: 0 name: \a
  t.same actual, expected, 'save fetched data'

  actual = merged.existing
  expected = name: \existing
  t.same actual, expected, 'keep existing data'

  action = type: \replace-collection payload: id: \t models: items
  merged = reduce state, action .app

  actual = merged?0
  t.ok actual, 'model path defaults to `app`'

  state = app:
    location: \main
    existing: value: 1
  action = type: \clear-model payload: model: \app id: \existing

  actual = reduce state, action .app?existing?value
  t.false actual, 'clear model values'

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

function main t
  collections t
  cache t
  actions t
  selector t

  t.end!

export default: main
