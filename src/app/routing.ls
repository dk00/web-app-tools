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

function get-location {data: app: {location}} {
  component, render, ...rest
}
  Object.assign {render: render || component, location} rest

function render-matched {path, location, exact, render}
  if parse-path location.pathname, path, {exact}
    (create-factory render) match: params: that
  else ''

route = with-state get-location <| render-matched

patch = 'http://placeholder'
function resolve-url path, base => new URL path, patch + base

function render-link {
  location, to: href, children, dispatch, active-class-name=\active
}
  url = resolve-url href, location.pathname
  active = url.pathname == location.pathname
  h \a Object.assign {children, href},
    if active then class: active-class-name
    on-click: ->
      it.prevent-default!
      if !active then dispatch update-location url

nav-link = with-state get-location <| render-link

if process.env.NODE_ENV != \production
  route.display-name = \route
  nav-link.display-name = \nav-link

export {route, nav-link, parse-path}
