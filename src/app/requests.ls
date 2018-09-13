import \./collection : {replace-collection}

function result-message models, {collection, model=collection}
  source: \app action: replace-collection {id: collection, model, models}

function request-model {collection, model=collection} => model

function request-options {collection, parameters: data, transform}
  Object.assign {collection, transform}, if data then {data}

function request-path {collection, model=collection} {prefix='/'}={}
  prefix + model

function without-id {id, ...rest} => rest

function fetch-options data, {token}={}
  Object.assign {},
    request-options parameters: data
    if token then headers: Authorization: "Bearer #{token}"

function syncing {collection, data} request
  model = request-model request
  collection?sync?items.some -> data.sync[it]model == model

function should-fetch {fetch, collection: id}: request, state={}
  !syncing state, request and
  fetch and fetch != \lazy || !state.collection[id]?items.length

function reduce-requests source, state
  requests = [].concat ...source.map ({requests=[] ...request}) ->
    requests.concat request
  requests.filter (request) -> should-fetch request, state
  .map (request) ->
    Object.assign {},
      request-options request
      model: request-model request

function request-config data: app: {service: {prefix, token}={}}
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
  init: Object.assign {method} fetch-options (without-id options.data), config

export {reduce-requests, result-message, request-config, fetch-args, save-fetch-args}
