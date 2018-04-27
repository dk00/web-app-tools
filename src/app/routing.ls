import
  \path-to-regexp : path-to-regexp
  \./with-state : with-state

function extract-parameters path, pattern, keys
  parsed = pattern.exec path
  if !parsed then void
  else
    entries = parsed.slice 1 .map (matched, index) ->
      (keys[index]name): matched
      #TODO keys w/o name
    Object.assign {} ...entries

function parse location, path
  keys = []
  pattern = path-to-regexp path, keys
  extract-parameters location, pattern, keys

function get-location {data: app: location} {path, render}
  {render}

function render-matched {render}
  render {}
  'qq'

route = with-state get-location <| render-matched

export {route, parse}
