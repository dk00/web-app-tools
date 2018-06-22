import
  './mock': {mock-fetch, render-once, set-props}
  '../src/app/with-fetch': with-fetch

function main t
  result = {}
  data = -> it
  global.fetch = mock-fetch data, -> result.fetch-args := it

  options =
    handle-result: (items, request) -> result.resolve {items, request}
    handle-error: -> console.log it
  wrapped = with-fetch options <| ->
  new Promise (resolve) ->
    props = collection: \p
    result.resolve = resolve
    result.first-element = render-once wrapped, {props}
  .then ->
    actual = it
    expected =
      items: url: '/p' init: body: void
      request: collection: \p
    t.same actual, expected, 'apply effect to fetch resource on mount'

  t.end!

export default: main
