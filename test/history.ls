import '../src/app/history' : {update-location, sync-history}

function mock-store
  state = {}
  listener = void

  instance =
    subscribe: -> listener := it
    get-state: -> state
    notify: ->
      state := it
      listener!
    dispatch: (payload: {model=\app id, values}) ->
      instance.notify data: (model): (id): values

function mock-window
  handle-nav = void
  entries = []

  instance =
    history:
      push-state: (,, url) ->
        entries.push url
        instance.location.pathname = url
        instance.history.length = entries.length
    location: {}
    add-event-listener: (name, handler) ->
      if name == \popstate then handle-nav := handler
    navigate: (url) ->
      instance.location = pathname: url
      handle-nav!

function mock-nav store, path
  store.notify data: app: location: pathname: path

function test-actions t
  search = '?q=1&nested[value]=2&array[1]=3&array[]=0'
  {payload: {values}} = update-location {pathname: '/route' search}

  actual = values.pathname
  expected = '/route'
  t.is actual, expected, 'copy pathname to update'

  actual = values.search?q
  expected = \1
  t.is actual, expected, 'values of search parameters'

  # TODO nested search parameters

function main t
  test-actions t

  store = mock-store!
  w = mock-window!
  sync-history store, w
  mock-nav store, '/next'

  actual = w.location.pathname
  expected = '/next'
  t.is actual, expected, 'sync location to browser on state update'

  mock-nav store, '/next'

  actual = w.history.length
  expected = 1
  t.is actual, expected, 'do nothing if state location is unchanged'

  w.navigate '/another'

  actual = store.get-state!data.app.location.pathname
  expected = '/another'
  t.is actual, expected, 'sync browser location to state'

  t.end!

export default: main
