import '../src/app/requests': {merge-requests, result-message}

function basic-requests t
  requests = [collection: \p]

  actual = merge-requests requests .0{path, request}
  expected = path: \/p request: collection: \p
  t.same actual, expected, 'pass single request'

  actual = merge-requests requests, prefix: 'https://api.io/' .0.path
  expected = 'https://api.io/p'
  t.is actual, expected, 'set prefix of api URL'

  parameters = remarks: 'request parameters' type: [\y \x]
  requests = [model: \p parameters: parameters]
  config = token: \access-token
  requests = merge-requests requests, config

  actual = requests.0.path
  expected = '/p'
  t.is actual, expected, 'request path'

  actual = requests.0.options?data
  expected = parameters
  t.same actual, expected, 'request parameters'

  actual = requests.0.options?headers
  expected = Authorization: 'Bearer access-token'
  t.same actual, expected, 'request token'

function messages t
  result = \models
  request = collection: \collection model: \model
  message = result-message result, request

  actual = message.action.type
  expected = \replace-collection
  t.is actual, expected, 'create message to update collection'

  request = model: \model
  message = result-message result, request

  actual = message.action.payload
  expected = id: void model: \model models: [\models]
  t.same actual, expected, 'update data cache only'

function main t
  basic-requests t
  messages t

  t.end!

export default: main
