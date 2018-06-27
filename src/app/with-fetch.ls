import
  'zero-fetch': fetch-object
  '../utils': {exclude, request-key}
  './with-effect': with-effect
  './merge-requests': merge-requests

function handle-request-changes state, requests, {handle-result, handle-error}
  new-requests = exclude requests, state.requests, request-key
  state.requests := requests
  new-requests.for-each ({path, options, request}) ->
    fetch-object path, options
    .then (items) -> handle-result items, request
    .catch handle-error

function fetch-options options, {store}
  Object.assign {}  store.get-state!data?app?fetch, options

function with-fetch options
  state = requests: []
  with-effect (instance-props, context) ->
    next = merge-requests instance-props, fetch-options options, context
    handle-request-changes state, next, options

export default: with-fetch
