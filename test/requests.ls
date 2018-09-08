import '../src/app/requests': {reduce-requests, result-message, save-fetch-args}

function basic-requests t
  requests = [collection: \p fetch: true]

  actual = reduce-requests requests .0.model
  expected = \p
  t.same actual, expected, 'pass single request'

  parameters = remarks: 'request parameters' type: [\y \x]
  requests = [model: \p fetch: true parameters: parameters, transform: -> it]
  config = token: \access-token
  requests = reduce-requests requests, config

  actual = requests.0.model
  expected = \p
  t.is actual, expected, 'request model'

  actual = requests.0.data
  expected = parameters
  t.same actual, expected, 'request parameters'

  actual = typeof requests.0.transform
  expected = \function
  t.is actual, expected, 'pass request transform functions'

function lazy-loading t
  requests =
    * collection: \loaded fetch: \lazy
    * collection: \to-be-fetched fetch: \lazy
    * collection: \never-fetch
  state = collection: loaded: items: [1]

  result = reduce-requests requests, state

  actual = result.find -> it.model == \loaded
  t.false actual, 'skip fetch if the collection is not empty'

  actual = result.find -> it.model == \never-fetch
  t.false actual, 'skip fetch if fetch option is not set'

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
  state = data: app: service:
    prefix: 'https://api.org/v0/'
    token: \access-token
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
    service: prefix: 'https://api.org/v0/'
  meta = collection: \inventory model: \product id: \2 data: value: 3
  {url, init} = save-fetch-args state, meta

  actual = "#{init.method} #url"
  expected = 'patch https://api.org/v0/product/2'
  t.is actual, expected, 'rest action to edit a resource entry'

function suspend t
  requests =
    * collection: \saving fetch: true
    * collection: \other fetch: true
  state =
    collection: sync: items: [0 1]
    data: sync:
      0: model: \saving
      1: model: \whatever
  result = reduce-requests requests, state

  actual = [\saving \other]map (model) -> result.some -> it.model == model
  .join ' '
  expected = 'false true'
  t.is actual, expected, 'suspend fetching while syncing'

function main t
  basic-requests t
  lazy-loading t
  messages t
  save t
  suspend t

  t.end!

export default: main
