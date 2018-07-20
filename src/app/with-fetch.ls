import
  'zero-fetch': fetch-object
  '../utils': {exclude, request-key}
  './with-effect': with-effect
  './requests': {merge-requests}

function handle-request-changes state, requests, {handle-result, handle-error}
  new-requests = exclude requests, state.requests, request-key
  state.requests := requests
  new-requests.for-each ({path, options, request}) ->
    fetch-object path, options
    .then (items) -> handle-result items, request
    .catch handle-error

function request-options options, {store}={}
  {fetch, user={}} = store?get-state!data?app or {}
  Object.assign {user.token} fetch, options

function with-fetch user-options
  state = requests: []
  with-effect (instance-props, context) ->
    options = request-options user-options, context
    next = merge-requests instance-props, options
    handle-request-changes state, next, options

export default: with-fetch
