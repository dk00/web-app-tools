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
    dispatch: (payload: {model=\app id, models}) ->
      instance.notify data: (model): Object.assign ...models.map ->
        (it.id): it

patch = 'https://placeholder'
function mock-window
  handle-nav = void
  entries = []

  instance =
    history:
      push-state: (,, path) ->
        entries.push path
        instance.location = new URL patch + path
        instance.history.length = entries.length
    location: {}
    add-event-listener: (name, handler) ->
      if name == \popstate then handle-nav := handler
    navigate: (path) ->
      instance.location = new URL patch + path
      handle-nav!

function mock-nav store, pathname, search={} hash
  store.notify data: app: {location: {pathname, hash} search}

function test-actions t
  search = '?q=1&nested[value]=2&array[1]=3&array[]=0'
  {type, payload: {models}} = update-location {pathname: '/route' search}

  actual = models?map (.id) .join ' '
  expected = 'location search'
  t.is actual, expected, 'update location state values'

  actual = models?0?pathname
  expected = '/route'
  t.is actual, expected, 'copy pathname to update'

  actual = models?1?q
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

  mock-nav store, '/next' query: \value

  actual = w.location.to-string!slice -17
  expected = '/next?query=value'
  t.is actual, expected, 'sync search parameters to browser location'

  entries = w.history.length
  mock-nav store, '/next' query: \value

  actual = w.history.length - entries
  expected = 0
  t.is actual, expected, 'do nothing if state query is not changed'

  mock-nav store, '/next' {} '#target'

  actual = w.location.to-string!includes '#target'
  t.ok actual, 'sync hash to browser location'

  w.navigate '/another#target'
  result = store.get-state!data.app.location

  actual = result.pathname
  expected = '/another'
  t.is actual, expected, 'sync browser location path to state'

  actual = result.hash
  expected = '#target'
  t.is actual, expected, 'sync browser location hash to state'

  t.end!

export default: main
