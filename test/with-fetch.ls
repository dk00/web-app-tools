import
  './mock': {mock-fetch, render-once, set-props, test-fetch}
  '../src/app/with-fetch': with-fetch

function main t
  test-fetch (result) ->
    options =
      handle-result: (items, request) -> result.resolve {items, request}
      handle-error: -> console.log it
    wrapped = with-fetch options <| ->
    render-once wrapped, props: collection: \p
  .then ->
    actual = it
    expected =
      items: url: '/p' init: body: void
      request: collection: \p
    t.same actual, expected, 'apply effect to fetch resource on mount'

  t.end!

export default: main
