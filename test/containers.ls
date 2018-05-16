import
  \../src/app/containers : {
    with-collection, with-model, linked-input, toggle, toggle-target
    require-data
  }
  \./mock :  {render-once, click, get-attribute, get-children, mock-fetch}

function basic t
  identity = -> it

  state =
    collection: dessert:
      model: \dessert
      items: [1]
    data: dessert: 1: name: \candy
  result = render-once (with-collection 'dessert' <| identity), {state}

  actual = result
  expected = models: [name: \candy]
  t.same actual, expected, 'pass collection content as props'

  action = void
  dispatch = -> action := it
  state = data: app: flag: value: 'link this'
  props = type: identity, id: \flag field: \value
  result = render-once linked-input, {state, props, dispatch} .attributes

  actual = result.value
  expected = 'link this'
  t.is actual, expected, 'pass state value to input'

  result.on-change target: value: \user-input

  actual = action
  expected = type: \update-model payload:
    model: void id: \flag values: value: \user-input
  t.same actual, expected, 'handle user input event'

  props = type: identity, id: \flag
  result = render-once linked-input, {state, props, dispatch} .attributes

  actual = result.value
  expected = 'link this'
  t.is actual, expected, 'input field key defaults to value'

  result.on-change target: value: \another-user-input

  actual = action?payload?values
  expected = value: \another-user-input
  t.same actual, expected, 'field update action key defaults to value'

  result = void
  props =
    type: identity, children: ['toggle display']
    model: \custom id: \flag field: \value
  {node-name, attributes, children} = toggle props
  state = data: custom: flag: value: true
  props = Object.assign {children} attributes
  {
    node-name, attributes, children
  } = render-once node-name, {state, props, dispatch}
  result = node-name Object.assign {children} attributes

  actual = result.class
  expected = \active
  t.is actual, expected, 'active elements have active class'

  actual = result.children?0
  expected = 'toggle display'
  t.is actual, expected, 'pass toggle content'

  result.on-click!

  actual = action
  expected = type: \update-model payload:
    model: \custom id: \flag values: value: false
  t.same actual, expected, 'alternate when clicking on toggle'

  {node-name, attributes} = toggle props
  state = data: {}
  {
    node-name, attributes, children
  } = render-once node-name, {state, props: attributes, dispatch}
  result = node-name attributes

  actual = result.class
  t.false actual, 'inactive elements have no class'

  t.end!

function test-toggle t
  state = data: custom: flag: value: true
  props = type: \div model: \custom id: \flag class: \menu

  {node-name, attributes} = render-once toggle-target, {state, props}
  result = node-name attributes

  actual = /active/test result.attributes.class
  t.true actual, 'add active class'

  actual = /menu/test result.attributes.class
  t.true actual, 'keep existing classes'

  t.end!

function data-req t
  result = fetch-args = void
  resolve-next = ->
  resolve-with = -> resolve-next it
  global.fetch = mock-fetch t: 1, ->
    resolve-with it

  props = collection: \dessert parameters: color: \pink
  collections = dessert: 'https://api.bakery.io/dessert'
  dispatch = -> result := it


  new Promise (resolve) ->
    resolve-next := resolve
    render-once require-data, {props, dispatch, options: {collections}}
  .then (fetch-args) ->
    [path, qs] = fetch-args.url.split \?

    actual = path
    expected = 'https://api.bakery.io/dessert'
    t.same actual, expected, 'fetch with resource url'

    actual = qs
    expected = \color=pink
    t.same actual, expected, 'fetch with encoded parameters'

    Promise.resolve!
  .then ->
    actual = result
    expected =
      type: \update-collection
      payload: id: \dessert model: \dessert models: [t: 1]
    t.same actual, expected, 'dispatch fetched result'

    global.fetch = void

    t.end!

function main t
  t.test '> Basic' basic
  t.test '> Toggle' test-toggle
  t.test '> Data Requirements' data-req

export default: main
