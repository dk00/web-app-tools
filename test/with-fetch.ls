import
  './mock': {mock-fetch, render-once, set-props, test-fetch}
  '../src/app/with-fetch': with-fetch

function main t
  test-fetch (result) ->
    options =
      handle-result: (items, request) -> result.resolve {items, request}
      handle-error: -> console.log it
    wrapped = with-fetch options <| ->
    state = data: app:
      fetch: prefix: 'http://api.com/'
      user: token: \access-token
    props = collection: \p
    render-once wrapped, {state, props}
  .then ->
    actual = it.request
    expected = collection: \p model: \p
    t.same actual, expected, 'apply effect to fetch resource on mount'

    actual = it.items.url
    expected = 'http://api.com/p'
    t.is actual, expected, 'use url prefix in state for fetch'

  t.end!

export default: main
