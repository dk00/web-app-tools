import '../src/app/merge-requests': merge-requests

function main t
  requests = [collection: \p]

  actual = merge-requests requests
  expected = [path: \/p data: {}]
  t.same actual, expected, 'pass single request'

  actual = merge-requests requests, prefix: 'https://api.io/' .0.path
  expected = 'https://api.io/p'
  t.is actual, expected, 'set prefix of api URL'

  t.end!

export default: main
