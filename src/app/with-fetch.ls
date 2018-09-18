import
  '../utils': {exclude, request-key}
  './with-effect': with-effect
  './requests': {reduce-requests, config-fetch}

function handle-request-changes state, requests
  new-requests = exclude requests, state.requests, request-key
  state.requests := requests
  new-requests

function transformed result, request, fetch-model
  transform = request.transform || -> Promise.resolve it
  transform result, request, fetch-model

function with-fetch user-options
  state = requests: []
  {handle-result, handle-error} = user-options
  with-effect (requests, context) ->
    return if !context
    fetch-model = config-fetch context.store.get-state!

    next = reduce-requests requests, context.store.get-state!
    handle-request-changes state, next
    .for-each (request) ->
      fetch-model request
      .then (result) -> transformed result, request, fetch-model
      .then (result) -> handle-result result, request
      .catch handle-error

export default: with-fetch
