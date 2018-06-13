import
  \../src/app/routing : {parse-path, route, nav-link}
  \./mock : {render-once, click, get-attribute, get-children}

function at-location
  data: app: location: pathname: it

function relative-link t
  state = at-location '/target/6'
  props = to: \1
  action = void
  element = render-once nav-link, {state, props, dispatch: -> action := it}
  click element

  actual = action.payload.values.pathname
  expected = '/target/1'
  t.same actual, expected, 'treat link relative if not starting with slash'

  props = to: \6
  element = render-once nav-link, {state, props, dispatch: -> action := it}

  actual = get-attribute element, \class ?includes \active
  t.ok actual, 'active relative links have active class'

  props = to: \/top
  element = render-once nav-link, {state, props}

  actual = get-attribute element, \href
  expected = \/top
  t.ok actual, 'absolute paths are unchanged'

function main t
  path = '/:path/:id'
  location = \/whatever/id

  actual = parse-path location, path
  expected = path: \whatever id: \id
  t.same actual, expected, 'parse location with specified path'

  actual = parse-path \somewhere \whatever
  t.false actual, 'return nothing if the location does not match'

  actual = parse-path '/match-start/1' '/match-start'
  t.true actual, 'match route path at the beginning'

  props = path: \/target render: -> \matched
  state = at-location \/target

  actual = render-once route, {props, state}
  expected = \matched
  t.is actual, expected, 'render specified component when the location matchs'

  props = path: '/target/:a/:b', render: (match: params: {a, b}) ->
    "parameters: #a #b"
  state = at-location '/target/qz/23'

  actual = render-once route, {props, state}
  expected = 'parameters: qz 23'
  t.is actual, expected, 'render with path parameters'

  props = path: \/no-match render: -> 'should not match'

  actual = render-once route, {props, state}
  t.false actual, 'render nothing if the location does not match'

  props = to: \/target children: 'link text'
  state = at-location '/target'
  element = render-once nav-link, {state, props}

  actual = get-attribute element, \class ?includes \active
  t.ok actual, 'active links have active class'

  actual = get-attribute element, \href
  expected = \/target
  t.is actual, expected, 'render link with the href attribute'

  actual = get-children element
  expected = 'link text'
  t.is actual, expected, 'render with link text'

  action = void
  props = to: \whatever
  element = render-once nav-link, {state, props, dispatch: -> action := it}

  actual = get-attribute element, \class ?.includes \active
  t.false actual, 'other links does not have active class'

  click element

  actual = action
  expected = type: \update-model payload:
    model: void id: \location values: pathname: \/whatever
  t.same actual, expected, 'navigate to specified location on click'

  relative-link t

  t.end!

export default: main
