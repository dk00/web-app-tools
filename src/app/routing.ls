import
  \path-to-regexp : path-to-regexp
  '../utils': {map-attributes}
  \./react : {h, create-factory}
  './hooks': {use-state, use-effect, use-ref, use-store-state}
  \./recompose : {with-state}
  './history': {update-location}
  './dom': {scroll-to-anchor}

function parse-path location, {path, exact=false}
  keys = []
  parsed = path-to-regexp path, keys, end: exact .exec location
  if !parsed then void
  else
    entries = parsed.slice 1 .map (matched, index) ->
      (keys[index]name): matched
      #TODO keys w/o name
    Object.assign {} ...entries

function empty => ''

function async-render {on-load, own-props}
  component = use-ref empty
  [loaded, set-loaded] = use-state false
  use-effect !->
    loaded || on-load ->
      component.current = it.default
      set-loaded true
  , []
  component.current own-props

function get-route-state {data: app: {location, search}} props
  matched = parse-path location.pathname, props
  if matched then {location, search, ...props} else void

function route-props {path, location, search, exact}
  if !location then void
  else
    params = parse-path location.pathname, {path, exact}
    match: {params}
    location: {search, ...location}

function setup-route render, props, cached
  cached.current = create-factory render
  element = cached.current props
  if element.then
    element.then -> cached.current = it.default
    h async-render, own-props: props, on-load: -> element.then it
  else element

function render-route {render, own-props, cached}
  if cached.current then cached.current own-props
  else setup-route render, own-props, cached

function route {component, render=component, ...options}
  cached = use-ref!
  own-props = route-props use-store-state get-route-state, options
  if !own-props then ''
  else h render-route, {render, own-props, cached}

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
      action = update-location resolve-url href, location.pathname
      post-message {source: \app action} \*
    Promise.resolve!then -> scroll-to-anchor global, scroll
  link-props = map-attributes Object.assign {on-click} others,
    if type == \a then {href}
    if active then class: active-class props

  h type, link-props, children

function render-button {to, location, active-class-name, children, dispatch, active, ...rest}
  others = Object.assign type: \button, rest
  render-link {type: \button to, location, active-class-name, children, dispatch, others}

nav-link = with-link-state render-link
nav-button = with-link-state render-button

if process.env.NODE_ENV != \production
  route.display-name = \route
  nav-link.display-name = \nav-link
  nav-button.display-name = \nav-button

export {route, nav-link, nav-button, parse-path}
