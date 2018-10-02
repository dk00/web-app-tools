function render-once component, {props={} state={} dispatch, options}: config
  if component? props
    {node-name, attributes, children} = that
    render-once node-name, Object.assign {} config, props:
      Object.assign {children} attributes
  else
    store = {dispatch, get-state: -> state}
    context = {options, store}
    self = {props, context}
    component::component-will-mount?call self
    element = (self.render || component::render)?call self
    component::component-did-mount?call self
    if \object == typeof element
      Object.assign element, {component, instance: self}
    else element

mock-event =
  prevent-default: ->
  stop-propagation: ->

function click element => element.attributes.on-click mock-event

function set-props {component, instance} props
  instance.props = props
  component::component-did-update?call instance

function unmount {component, instance}
  component::component-will-unmount?call instance

function get-attribute element, key => element.attributes[key]
function get-children element => element.children.0

function mock-fetch data, save-args
  headers = 'content-type': 'application/json'
  fn = (url, init) ->
    result =
      headers: get: -> headers[it]
      json: ->
        save-args? {url, init}
        data? {url, init} or data
    Promise.resolve result

function test-fetch render
  result = {}
  data = -> it
  global.fetch = mock-fetch data, -> result.fetch-args := it
  new Promise (resolve) ->
    Object.assign result, {resolve, element: render result}

export {
  render-once, click, set-props, unmount
  get-attribute, get-children,
  mock-fetch, test-fetch, mock-event
}
