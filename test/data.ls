import
  \../src/app/actions : {handle-actions}
  \../src/app/data : {reduce: reduce-data, fetch-data}

function main t
  actual = fetch-data collection: \collection path: \path items: [id: \id]
  expected = type: \fetch payload:
    collection: \collection path: \path items: [id: \id]
  t.same actual, expected, 'create action to fetch data'

  actual = fetch-data path: \path items: [id: \id] .payload.collection
  expected = \path
  t.is actual, expected, 'fetch target collection default to path'

  items =
    * id: 0 name: \a
    * id: 1 name: \b
  action = type: \fetch payload: {collection: \t path: \t items}
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
  action = type: \update-data payload:
    path: \app id: \tab-index
    values: \env-info : 2

  actual = reduce state, action .app
  expected =
    location: \main
    \tab-index : id: \tab-index \env-info : 2
  t.same actual, expected, 'update values specified path'

  actual = reduce {} action .app'tab-index'.'env-info'
  expected = 2
  t.same actual, expected, 'update values to not existing'

  state = app: 'sensor-types': humidity: true
  action = type: \toggle-value payload:
    path: \app id: \sensor-types key: \temperature

  actual = reduce state, action .app\sensor-types
  expected =  id: \sensor-types temperature: true humidity: true
  t.same actual, expected, 'toggle single data value'


  state = app: flags: existing: true
  actions =
    * type: \update-data payload: id: \flags values: update: true
    * type: \toggle-value payload: id: \flags key: \toggle

  actual = actions.reduce reduce, state .app.flags
  expected = existing: true update: true toggle: true id: \flags
  t.same actual, expected, 'data action target path defaults to app'

  t.end!

export default: main
