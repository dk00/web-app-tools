import
  \../src/app/containers : {
    with-collection, with-model, linked-input, toggle, toggle-target
  }
  \./mock :  {
    render-once, click, get-attribute, get-children
    mock-fetch, test-fetch
  }

function identity => it

function collection t
  state =
    collection: dessert:
      model: \dessert
      items: [1]
    data: dessert: 1: name: \candy
  props = collection: \dessert
  result = render-once (with-collection {} <| identity), {state, props}

  actual = result.models
  expected = [name: \candy]
  t.same actual, expected, 'pass collection content as props'

  test-fetch (result) ->
    global.post-message = -> result.resolve it
    component = with-collection fetch: true <| identity
    render-once component, {state, props}
  .then ->
    actual = it.action.type
    expected = \replace-collection
    t.same actual, expected, 'fetch collection data on mount'

function basic t

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

  collection t .then -> t.end!

function main t
  t.test '> Basic' basic
  t.test '> Toggle' test-toggle

export default: main
