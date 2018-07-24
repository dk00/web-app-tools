import '../src/app/requests': {merge-requests, result-message, save-fetch-args}

function basic-requests t
  requests = [collection: \p]

  actual = merge-requests requests .0.model
  expected = \p
  t.same actual, expected, 'pass single request'

  parameters = remarks: 'request parameters' type: [\y \x]
  requests = [model: \p parameters: parameters, transform: -> it]
  config = token: \access-token
  requests = merge-requests requests, config

  actual = requests.0.model
  expected = \p
  t.is actual, expected, 'request model'

  actual = requests.0.data
  expected = parameters
  t.same actual, expected, 'request parameters'

  actual = typeof requests.0.transform
  expected = \function
  t.is actual, expected, 'pass request transform functions'

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

function save t
  state = data: app:
    fetch: prefix: 'https://api.org/v0/'
    user: token: \access-token
  meta = collection: \inventory model: \product data: value: \data
  {url, init} = save-fetch-args state, meta

  actual = "#{init.method} #url"
  expected = 'post https://api.org/v0/product'
  t.is actual, expected, 'rest action to create a resource entry'

  actual = init.headers.Authorization
  expected = 'Bearer access-token'
  t.is actual, expected, 'update requests includes access token'

  meta = collection: \inventory model: \product id: \new data: value: \data
  {init} = save-fetch-args state, meta
  actual = init.method
  expected = 'post'
  t.is actual, expected, 'treat {id: new} as insersion'

  actual = init.data
  expected = value: \data
  t.same actual, expected, 'data for update'

  state = data: app:
    fetch: prefix: 'https://api.org/v0/'
  meta = collection: \inventory model: \product id: \2 data: value: 3
  {url, init} = save-fetch-args state, meta

  actual = "#{init.method} #url"
  expected = 'patch https://api.org/v0/product/2'
  t.is actual, expected, 'rest action to edit a resource entry'

function main t
  basic-requests t
  messages t
  save t

  t.end!

export default: main
