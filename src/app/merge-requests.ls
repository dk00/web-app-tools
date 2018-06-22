function merge-requests requests, {prefix='/'}={}
  requests.map (request) ->
    options = {}
    {path: prefix + request.collection, options, request}

export default: merge-requests
