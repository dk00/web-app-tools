import \../src/app/fetch-params : fetch-params

function main t
  actual = fetch-params \t {} .0
  expected = \t
  t.is actual, expected, 'fetch w/o parameters'

  params = fetch-params \t params: a: 1

  actual = params.0
  expected = 't?a=1'
  t.is actual, expected, 'URL search parameters'

  actual = params.1.credentials
  expected = \include
  t.is actual, expected, 'credentials: include'

  params = fetch-params \t method: \post params: b: 2

  actual = params.0
  expected = \t
  t.is actual, expected, 'use the same URL for POST'

  actual = params.1.method
  expected = \post
  t.is actual, expected, 'set HTTP verb'

  actual = params.1.body
  expected = JSON.stringify b: 2
  t.is actual, expected, 'encode payload'

  FormData = {}
  data = Object.create FormData
  init = fetch-params \t method: \post data: data .1

  actual = init.body
  expected = data
  t.is actual, expected, 'POST with form data'

  actual = fetch-params \t parameters: a: 1 .0
  expected = 't?a=1'
  t.is actual, expected, 'accept new argument name: parameter'

  path = fetch-params \t parameters: a: 1 b: c: 2 .0
  actual = decodeURIComponent path
  expected = 't?a=1&b[c]=2'
  t.is actual, expected, 'query string for nested parameters'

  t.end!

export default: main
