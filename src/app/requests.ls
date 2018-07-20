import \./collection : {replace-collection}

function result-message models, {collection, model=collection}
  source: \app action: replace-collection {id: collection, model, models}

function request-path {collection, model=collection} {prefix='/'}={}
  prefix + model

function with-out-id {id, ...rest} => rest

function fetch-options data, {token}={}
  Object.assign {},
    if data then data: with-out-id data
    if token then headers: Authorization: "Bearer #{token}"

function merge-requests requests, config
  requests.map (request) ->
    options = fetch-options request.parameters, config
    {path: (request-path request, config), options, request}

function request-config data: app: {fetch: {prefix} user: {token}={}}
  {prefix, token}

function request-action {id}
  if id && id != \new then method: \patch tail: "/#id" else method: \post tail: ''

function save-fetch-args state, options
  config = request-config state
  {method, tail} = request-action options
  base-path = request-path options, config

  url: base-path + tail
  init: Object.assign {method} fetch-options options.data, config

export {merge-requests, result-message, save-fetch-args}
