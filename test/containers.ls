import
  \../src/app/containers : {
    with-list-data, with-collection, with-model
    linked-input, toggle, toggle-target
  }
  '../src/app/collection': {collection-state, collection-props}
  '../src/app/input': {have-options, select-source, model-options}
  \./mock :  {
    render-once, unmount, click, get-attribute, get-children
    mock-fetch, test-fetch, mock-event
  }
  '../src/utils': {identity}

function render-child {node-name: type, instance: {props, context}}
  render-once type, {props, state: context.store.get-state!}

function collection t
  state =
    collection: dessert:
      model: \dessert
      items: [1]
    data:
      app: service: {}
      dessert: 1: name: \candy
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

  result.on-click mock-event

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

function list-data t
  result = void
  props =
    collection: \language
    model: \lang
    fields: [\name \ratio]
  state =
    collection: language: items: [\en \ja]
    data: app: {} field:
      'lang.name': name: \Name
      'lang.ratio': name: \Ratio
  list = with-list-data -> result := it
  node = render-once list, {state, props}
  render-once node.node-name, {state, props: node.attributes}
  unmount node

  actual = result.items?join ' '
  expected = 'en ja'
  t.is actual, expected, 'get id of list items'

function selection t
  state =
    collection: source: model: \source items: [\origin \b]
    data: app: {} source:
      b: id: \b name: \Backup
      origin: id: \origin name: \Origin
  props = field: \source type: \select

  result = if have-options props
    model-options collection-props collection-state state, select-source props

  actual = result.options
  expected =
    * value: \origin label: \Origin
    * value: \b label: \Backup
  t.same actual, expected, 'pass constant options to input components'

  props = field: \sourceId
  source = select-source props
  result =  model-options collection-props collection-state state, source

  actual = result.options
  expected =
    * value: \origin label: \Origin
    * value: \b label: \Backup
  t.same actual, expected, 'pass model options to input components'

  actual = source.requests.every -> it.fetch == \lazy
  t.ok actual, 'skip fetching if have cached option data to select'

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
  list-data t
  selection t
  t.test '> Toggle' test-toggle

export default: main
