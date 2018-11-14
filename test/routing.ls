import
  \../src/app/routing : {route, nav-link}
  \./mock : {render-once, click, get-attribute, get-children}

function at-location pathname, search
  data: app: {search, location: {pathname, hash: ''}}

function test-link {base, to, run}
  state = at-location '/target/6'
  props = {to}
  action = void
  element = render-once nav-link, {state, props, dispatch: -> action := it}
  run && click element

  {element, action}

function relative-link t
  {element, action} = test-link base: '/target/6' to: \1 run: true

  actual = action.payload.models.0.pathname
  expected = '/target/1'
  t.same actual, expected, 'treat link relative if not starting with slash'

  {element} = test-link base: '/target/6' to: \6

  actual = get-attribute element, \class ?includes \active
  t.ok actual, 'active relative links have active class'

  {element} = test-link base: '/target/6' to: \/top

  actual = get-attribute element, \href
  expected = \/top
  t.is actual, expected, 'absolute paths are unchanged'

function search-parameters t
  {action} = test-link base: '/home' to: '/home?query=value' run: true

  actual = action.payload.models?1{query}
  expected = query: \value
  t.same actual, expected, 'convert query string in link'

function active-class-name t
  state = at-location '/here'
  props = to: '/here' active-class-name: \open

  element = render-once nav-link, {state, props}

  actual = get-attribute element, \class ?.includes \open
  t.ok actual, 'custom active link class'

function exact-route-path t
  state = at-location \/target/1
  props = path: \/target exact: true, render: -> \match

  actual = render-once route, {props, state}
  t.false actual, 'match exactly when exact is specified'

function route-props t
  state = at-location \/whatever/id q: \search-params
  props = path: \/ render: (location: search: {q}) -> q

  actual = render-once route, {props, state}
  expected = 'search-params'
  t.is actual, expected, 'pass search params as props'

function main t
  Object.assign global,
    location: {}
    query-selector: ->
    scroll-to: ->
  path = '/:path/:id'
  location = \/whatever/id

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
  expected = type: \replace-collection payload:
    id: void model: \app models:
      * id: \location pathname: \/whatever hash: ''
      * id: \search
  t.same actual, expected, 'navigate to specified location on click'

  exact-route-path t
  route-props t
  relative-link t
  search-parameters t
  active-class-name t

  t.end!

export default: main
