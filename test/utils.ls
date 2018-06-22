import \../src/utils : {deep-merge, request-key, exclude}

function test-request-key t
  actual = request-key path: '/p' data: id: [3]
  expected = '/p {"id":[3]}'
  t.is actual, expected, 'convert requests to string for diff'

function test-exclude t
  existing =
    * path: \/p data: {}
    * path: \/r data: id: [2]
  items =
    * path: \/p data: {}
    * path: \/q data: id: [3]

  new-items = exclude items, existing, request-key

  actual = new-items.map request-key .join ' '
  expected = '/q {"id":[3]}'
  t.is actual, expected, 'exclude specified items'

function main t
  actual = deep-merge {a: b: 2} a: c: 0
  expected = a: b: 2 c: 0
  t.same actual, expected, 'merge inner objects'

  actual = deep-merge {a: value: 'should replace'} a: \base-type
  expected = a: \base-type
  t.same actual, expected, 'replace object with base type values'

  test-request-key t
  test-exclude t

  t.end!

export default: main
