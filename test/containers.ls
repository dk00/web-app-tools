import
  \../src/app/containers : {
    with-collection, with-model, with-select-options
    linked-input, toggle, toggle-target
  }
  \./mock :  {
    render-once, click, get-attribute, get-children
    mock-fetch, test-fetch
  }

function identity => it

function render-child {node-name: type, instance: {props, context}}
  render-once type, {props, state: context.store.get-state!}

function collection t
  state =
    collection: dessert:
      model: \dessert
      items: [1]
    data: dessert: 1: name: \candy
  props = collection: \dessert
  nested = render-once (with-collection identity), {state, props}
  result = render-child nested

  actual = result.models
  expected = [name: \candy]
  t.same actual, expected, 'pass collection content as props'

  test-fetch (result) ->
    global.post-message = -> result.resolve it
    component = with-collection identity
    render-once component, {state, props: Object.assign fetch: true, props}
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

  props = type: identity, id: \flag field: \whatever default-value: \default
  result = render-once linked-input, {state, props, dispatch} .attributes

  actual = result.value
  expected = \default
  t.is actual, expected, 'input value fallbacks to defaultValue'

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

function selection t
  result = void
  linked = with-select-options -> result := it
  state =
    collection: source: model: \source items: [\origin \b]
    data: source:
      b: id: \b name: \Backup
      origin: id: \origin name: \Origin
  props = field: \source
  nested = render-once linked, {state, props}
  render-child nested

  actual = result.options
  expected =
    * value: \origin label: \Origin
    * value: \b label: \Backup
  t.same actual, expected, 'pass constant options to input components'

  #TODO lazy fetch
  sequence = []
  global.fetch = ->
    sequence.push \fetch
    Promise.resolve headers: get: ->
  global.post-message = ->
  props = field: \sourceId
  nested = render-once linked, {state, props}
  render-child nested

  actual = result.options
  expected =
    * value: \origin label: \Origin
    * value: \b label: \Backup
  t.same actual, expected, 'pass model options to input components'

  actual = sequence.join ' '
  expected = ''
  t.is actual, expected, 'skip fetching if have cached option data to select'

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
  selection t
  t.test '> Toggle' test-toggle

export default: main
