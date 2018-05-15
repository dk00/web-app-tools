import \../src/app/sync : {api-url}

function main t
  context = options: base-url: \/my-api/

  actual = api-url context, \whatever
  expected = '/my-api/whatever'
  t.is actual, expected, 'custom base restful API url'

  context = options: collections: whatever: 'https://my-api.io/w'

  actual = api-url context, \whatever
  expected = 'https://my-api.io/w'
  t.is actual, expected, 'collection specfic api url'

  t.end!

export default: main
