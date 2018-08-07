import
  'zero-fetch': fetch-object
  '../utils': {exclude, request-key}
  './with-effect': with-effect
  './requests': {reduce-requests, fetch-args}

function handle-request-changes state, requests
  new-requests = exclude requests, state.requests, request-key
  state.requests := requests
  new-requests

function fetch-options data: app: {fetch, user={}}={}
  Object.assign {user.token} fetch

function setup-fetch {store}
  options = fetch-options store.get-state!
  (request) ->
    {url, init} = fetch-args request, options
    fetch-object url, init

function transformed result, request, fetch-model
  transform = request.transform || -> Promise.resolve it
  transform result, request, fetch-model

function with-fetch user-options
  state = requests: []
  {handle-result, handle-error} = user-options
  with-effect (instance-props, context) ->
    return if !context
    fetch-model = setup-fetch context

    next = reduce-requests instance-props, context.store.get-state!
    handle-request-changes state, next
    .for-each (request) ->
      fetch-model request
      .then (result) -> transformed result, request, fetch-model
      .then (result) -> handle-result result, request
      .catch handle-error

export default: with-fetch
