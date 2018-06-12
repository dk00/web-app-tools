import
  \path-to-regexp : path-to-regexp
  \./react : {h, create-factory}
  \./recompose : {with-state}
  \./collection : {update-model}

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
  pattern = path-to-regexp path, keys, end: false
  extract-parameters location, pattern, keys

function render-nothing => ''

function get-location {data: app: {location}} {to, path, component, render, children}
  {to, location, path, children, render: render || component}

function render-matched {path, location, render}
  result = if parse-path location.pathname, path then params: that
  if result then (create-factory render) match: result
  else ''

route = with-state get-location <| render-matched

function navigate pathname
  update-model id: \location values: {pathname}

function render-link {location, to: pathname, children, dispatch}
  active = pathname == location.pathname
  h \a Object.assign {children, href: pathname},
    if active then class: \active
    on-click: ->
      it.prevent-default!
      if !active then dispatch navigate pathname

nav-link = with-state get-location <| render-link

if process.env.NODE_ENV != \production
  route.display-name = \route
  nav-link.display-name = \nav-link

export {route, nav-link, parse-path}
