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

function parse-path location, path
  keys = []
  pattern = path-to-regexp path, keys
  extract-parameters location, pattern, keys

function render-nothing => ''

function get-location {data: app: location: {pathname}} {path, render}
  result = if parse-path pathname, path then params: that
  render: if result then render else render-nothing
  match: result

function render-matched {render, match: match-result}
  render match: match-result

route = with-state get-location <| render-matched

export {route, parse-path}
