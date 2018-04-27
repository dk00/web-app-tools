import \../src/app/routing : {route, parse}

function render-once component, props, state
  self = {props, context: store: get-state: -> state}
  route::component-will-mount.call self
  route::render.call self

function main t
  path = '/:path/:id'
  location = \/whatever/id

  actual = parse location, path
  expected = path: \whatever id: \id
  t.same actual, expected, 'parse location with specified path'

  actual = parse \somewhere \whatever
  t.false actual

  props = path: \/target render: -> \matched
  state = data: app: location: pathname: \/target

  actual = render-once route, props, state
  expected = \matched
  t.is actual, expected, 'renders specified component when the location matchs'

  t.end!

export default: main
