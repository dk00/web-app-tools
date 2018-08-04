function q => document.query-selector it
function qa => Array.from document.query-selector-all it

function h tag-name, attributes
  element = document.create-element tag-name
  Object.assign element, attributes

function require-script
  new Promise (resolve) ->
    element = h \script src: it, onload: resolve
    document.body.append element

function require-scripts
  it.reduce (last, url) -> last.then -> require-script url
  , Promise.resolve!

# https://stackoverflow.com/a/22966637/4578017
function remove-children node
  range = document.create-range!
  range.select-node-contents node
  range.delete-contents
  node

function add-event-listener target, name, listener, options
  target.add-event-listener name, listener, options
  -> target.remove-event-listener name, listener

function passive target, name, listener
  add-event-listener target, name, listener, passive: true

function till target, name, test => new Promise (resolve) ->
  remove = add-event-listener target, name, ->
    if test it.data
      remove!
      resolve it.data

function on-visibility-change listener
  passive global, \scroll ->
    el = document.document-element
    data = height: el.client-height, width: el.client-width
    listener data

function above-view element, {height, ratio=1}
  {top, bottom} = element.get-bounding-client-rect!
  offset = height - top
  element-height = Math.min height, bottom - top
  offset >= element-height*ratio

export {q, qa}
export {require-scripts, remove-children}
export {add-event-listener, passive, till}
export {above-view, on-visibility-change}
