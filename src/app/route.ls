import \path-to-regexp : path-to-regexp

function extract-parameters path, pattern, keys
  parsed = pattern.exec path or []
  entries = parsed.slice 1 .map (matched, index) ->
    (keys[index]name): matched
    #TODO keys w/o name
  Object.assign {} ...entries

function parse location, path
  keys = []
  pattern = path-to-regexp path, keys
  extract-parameters location, pattern, keys

function handle-routes routes, get-path
  #TODO handle 404
  route-tuples = Object.entries routes .map ([path, handler]) ->
    keys = []
    pattern = path-to-regexp path, keys
    [pattern, keys, handler]

  (full-path) ->
    path = get-path? full-path or full-path
    [pattern, keys, handler]? = route-tuples.find ([pattern]) ->
      pattern.test path
    handler? extract-parameters path, pattern, keys

export {handle-routes, parse}
