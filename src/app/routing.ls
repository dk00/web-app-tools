import
  \path-to-regexp : path-to-regexp
  \./react : {h, create-factory}
  \./recompose : {with-state}
  './history': {update-location}
  './dom': {scroll-to-anchor}
  './async-component': async-component

function parse-path location, {path, exact=false}
  keys = []
  parsed = path-to-regexp path, keys, end: exact .exec location
  if !parsed then void
  else
    entries = parsed.slice 1 .map (matched, index) ->
      (keys[index]name): matched
      #TODO keys w/o name
    Object.assign {} ...entries

function render-nothing => ''

function async-render request, props
  h (async-component -> request), props

function get-route-state {data: app: {location, search}} props
  matched = parse-path location.pathname, props
  if matched then {location, search, ...props} else void

function render-matched {path, location, search, exact, component, render=component}
  element = if !location then ''
  else
    params = parse-path location.pathname, {path, exact}
    props = match: {params} location: {search, ...location}
    create-factory render <| props
  if element.then then async-render element, props else element

route = with-state get-route-state <| render-matched

patch = 'http://placeholder'
function resolve-url path, base => new URL path, patch + base

function active-class {active-class-name=\active others}
  (others?class || '') + ' ' + active-class-name

function anchor-path {pathname, hash} => pathname + hash

function url-equal a, b => (anchor-path a) == anchor-path b

with-link-state = with-state ({data: app: {location}} props) ->
  url = resolve-url props.to, location.pathname
  active = url-equal url, location
  {active, ...props}

function render-link props
  {type=\a to: href, scroll, others, children, active, dispatch} = props
  on-click = ->
    it.prevent-default!
    if !active
      dispatch update-location resolve-url href, location.pathname
    Promise.resolve!then -> scroll-to-anchor global, scroll
  link-props = Object.assign {on-click} others,
    if type == \a then {href}
    if active then class: active-class props

  h type, link-props, children

function render-button {to, location, active-class-name, children, dispatch, ...rest}
  others = Object.assign  type: \button, rest
  render-link {type: \button to, location, active-class-name, children, dispatch, others}

nav-link = with-link-state render-link
nav-button = with-link-state render-button

if process.env.NODE_ENV != \production
  route.display-name = \route
  nav-link.display-name = \nav-link
  nav-button.display-name = \nav-button

export {route, nav-link, nav-button, parse-path}
