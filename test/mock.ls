function render-once component, {props={} state={} dispatch, options}
  store = {dispatch, get-state: -> state}
  context = {options, store}
  self = {props, context}
  component::component-will-mount?call self
  element = self.render?call self
  component::component-did-mount?call self
  element

function click element => element.attributes.on-click prevent-default: ->
function get-attribute element, key => element.attributes[key]
function get-children element => element.children.0

function mock-fetch data, save-args
  fn = (url, init) ->
    Promise.resolve json: ->
      save-args? {url, init}
      data

export {render-once, click, get-attribute, get-children, mock-fetch}
