import \../src/app/route : {handle-routes, parse}

function main t
  routes =
    '/path': -> 'path'
    '/action/:id': -> it

  route = handle-routes routes

  actual = route \/path
  expected = \path
  t.is actual, expected, 'route simple to specified functions'

  actual = route \/action/sample-id
  expected = id: \sample-id
  t.same actual, expected, 'route path with parameters'

  route = handle-routes routes, -> \/ + it.split \/ .slice -1

  actual = route \/prefix/prefix/path
  expected = \path
  t.is actual, expected, 'route path with prefix'

  path = '/:path/:id'
  location = \/whatever/id

  actual = parse location, path
  expected = path: \whatever id: \id
  t.same actual, expected, 'parse location with specified path'

  t.end!

export default: main
