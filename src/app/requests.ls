import \./collection : {update-collection}

function result-message models, {collection, model=collection}
  source: \app action: update-collection {id: collection, model, models}

function merge-requests requests, {prefix='/'}={}
  requests.map (request) ->
    options = {}
    {path: prefix + request.collection, options, request}

export {merge-requests, result-message}
