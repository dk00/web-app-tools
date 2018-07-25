import
  \path-to-regexp : path-to-regexp
  \./react : {h, create-factory}
  \./recompose : {with-state}
  './history': {update-location}

function extract-parameters path, pattern, keys
  parsed = pattern.exec path
  if !parsed then void
  else
    entries = parsed.slice 1 .map (matched, index) ->
      (keys[index]name): matched
      #TODO keys w/o name
    Object.assign {} ...entries

function parse-path location, path, {exact=false}={}
  keys = []
  pattern = path-to-regexp path, keys, end: exact
  extract-parameters location, pattern, keys

function render-nothing => ''

function get-location {data: app: {location, search}} {
  component, render, ...rest
}
  Object.assign {render: render || component, location, search} rest

function render-matched {path, location, search, exact, render}
  if parse-path location.pathname, path, {exact}
    props = match: {params: that} location: Object.assign {search} location
    create-factory render <| props
  else ''

route = with-state get-location <| render-matched

patch = 'http://placeholder'
function resolve-url path, base => new URL path, patch + base

function active-class {active-class-name=\active others}
  (others?class || '') + ' ' + active-class-name

function render-link props
  {type=\a location, to: href, others, children, dispatch} = props
  url = resolve-url href, location.pathname
  active = url.pathname == location.pathname
  props = Object.assign {} others, {href},
    if active then class: active-class props
    on-click: ->
      it.prevent-default!
      if !active then dispatch update-location url
  h type, props, children

function render-button {to, location, active-class-name, children, dispatch, ...rest}
  others = Object.assign  type: \button, rest
  render-link {type: \button to, location, active-class-name, children, dispatch, others}

nav-link = with-state get-location <| render-link
nav-button = with-state get-location <| render-button

if process.env.NODE_ENV != \production
  route.display-name = \route
  nav-link.display-name = \nav-link
  nav-button.display-name = \nav-button

export {route, nav-link, nav-button, parse-path}
