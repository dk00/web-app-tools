function render-once component, {props={} state={} dispatch}
  self = {props, context: store: {dispatch, get-state: -> state}}
  component::component-will-mount.call self
  self.render.call self

function click element => element.attributes.on-click prevent-default: ->
function get-attribute element, key => element.attributes[key]
function get-children element => element.children.0

export {render-once, click, get-attribute, get-children}
