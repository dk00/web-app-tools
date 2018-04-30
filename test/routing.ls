import \../src/app/routing : {route, parse-path}

function render-once component, props, state
  self = {props, context: store: get-state: -> state}
  route::component-will-mount.call self
  self.render.call self

function at-location
  data: app: location: pathname: it

function main t
  path = '/:path/:id'
  location = \/whatever/id

  actual = parse-path location, path
  expected = path: \whatever id: \id
  t.same actual, expected, 'parse location with specified path'

  actual = parse-path \somewhere \whatever
  t.false actual, 'return nothing if the location does not match'

  props = path: \/target render: -> \matched
  state = at-location \/target

  actual = render-once route, props, state
  expected = \matched
  t.is actual, expected, 'render specified component when the location matchs'

  props = path: '/target/:a/:b', render: (match: params: {a, b}) ->
    "parameters: #a #b"
  state = at-location '/target/qz/23'

  actual = render-once route, props, state
  expected = 'parameters: qz 23'
  t.is actual, expected, 'render with path parameters'

  props = path: \/no-match render: -> 'should not match'
  actual = render-once route, props, state
  t.false actual, 'render nothing if the location does not match'

  t.end!

export default: main
