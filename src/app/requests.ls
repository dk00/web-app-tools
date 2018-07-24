import \./collection : {replace-collection}

function result-message models, {collection, model=collection}
  source: \app action: replace-collection {id: collection, model, models}

function request-model {collection, model=collection} => model

function request-options parameters: data
  if data then data: without-id data

function request-path {collection, model=collection} {prefix='/'}={}
  prefix + model

function without-id {id, ...rest} => rest

function fetch-options data, {token}={}
  Object.assign {},
    request-options parameters: data
    if token then headers: Authorization: "Bearer #{token}"

function merge-requests requests, config
  requests.map (request) ->
    options = fetch-options request.parameters, config
    {
      collection: request.collection
      model: request-model request
      ...request-options request
    }

function request-config data: app: {fetch: {prefix} user: {token}={}}
  {prefix, token}

function request-action {id}
  if id && id != \new then method: \patch tail: "/#id" else method: \post tail: ''

function fetch-args request, options
  url: request-path request, options
  init: fetch-options request.data, options

function save-fetch-args state, options
  config = request-config state
  {method, tail} = request-action options
  base-path = request-path options, config

  url: base-path + tail
  init: Object.assign {method} fetch-options options.data, config

export {merge-requests, result-message, fetch-args, save-fetch-args}
