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

export {q, qa}
export {require-scripts, remove-children}
