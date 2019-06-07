import
  'path-to-regexp': path-to-regexp
  './react': {h}
  './store': {use-store, use-store-state}

function get-route-match {location}: state, {pattern, keys}
  result = pattern.exec location.pathname
  if !result then match: false
  else
    entries = result.slice 1 .map (matched, index) ->
      (keys[index]name): matched
      #TODO keys w/o name
    match: params: Object.assign {} ...entries
    location: location

function match-options {path, exact}
  keys = []
  pattern = path-to-regexp path, keys, end: exact
  {pattern, keys}

function route {path, exact, render}
  props = use-store-state get-route-match, match-options {path, exact}
  if props.match then h render, props else ''

location-actions =
  navigate: (, to) ->
    origin = window.location
    new URL to, origin .{protocol, hostname, port, pathname, search}

function navigate => type: \navigate payload: it

function add-active {class-name, class: styles=class-name || ''}={}
  styles + ' active'

function nav-link {type=\a to, exact, children, ...others}
  {dispatch} = use-store!
  props = use-store-state get-route-match, match-options {path: to, exact}
  attributes = Object.assign {} others,
    on-click: ->
      it.prevent-default!
      dispatch navigate to
    if props.match then class-name: add-active others

  h type, attributes, children

export {route, nav-link, location-actions, navigate}
