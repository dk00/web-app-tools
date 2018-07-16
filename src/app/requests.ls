import \./collection : {replace-collection}

function result-message models, {collection, model=collection}
  source: \app action: replace-collection {id: collection, model, models}

function request-path {collection, model=collection} {prefix='/'}={}
  prefix + model

function merge-requests requests, config
  requests.map (request) ->
    options = data: request.parameters
    {path: (request-path request, config), options, request}

export {merge-requests, result-message}
