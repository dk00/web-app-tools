import
  \../src/app/containers : {with-collection, linked-input, toggle}
  \./mock :  {render-once, click, get-attribute, get-children}

function main t
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
  {node-name, attributes, children} =  toggle props
  state = data: custom: flag: value: true
  props = Object.assign {children} attributes
  {
    node-name, attributes, children
  } = render-once node-name, {state, props, dispatch}
  result = node-name Object.assign {children} attributes

  actual = result.value
  expected = true
  t.is actual, expected, 'get checked status'

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

  actual = \class of result
  t.false actual, 'inactive elements have no class'

  t.end!

export default: main
