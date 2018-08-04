import
  '../src/app/dom': {
    add-event-listener, till, passive, above-view, on-visibility-change
  }

function bounding-box top, bottom
  get-bounding-client-rect: -> {top, bottom}

function visibility t
  actual = above-view (bounding-box 200 300), height: 640
  t.ok actual, 'element is above if top offset is lower than height'

  actual = above-view (bounding-box 650 750), height: 640
  t.false actual, 'element is not above if top offset is greater than height'

  result = response = void
  Object.assign global,
    document: document-element:
      client-height: 640
      client-width: 320
    add-event-listener: (name, listener) ->
      response := listener

  on-visibility-change ({height}) -> result := height
  response!

  actual = result
  expected = 640
  t.is actual, expected, 'get visibility change event with details'

function events t
  listeners = {}
  settings = {}
  target =
    add-event-listener: (name, handler, options) ->
      settings[name] = options
      listeners[name] = handler
    remove-event-listener: (name, handler) -> \removed
  un = add-event-listener target, \name -> \handler

  actual = listeners.name!
  expected = \handler
  t.is actual, expected, 'attach event listener to the target'

  actual = un!
  expected = \removed
  t.is actual, expected, 'get a function to remove the listener'

  passive target, \scroll ->

  actual = settings.scroll.passive
  t.ok actual, 'attach passive event handler'

  wait = till target, \name -> it.type == \update

  listeners.name data: type: \other payload: \other-event
  listeners.name data: type: \update payload: \target-event

  wait.then ->
    actual = it.payload
    expected = \target-event
    t.is actual, expected, 'wait for specfic event once'

function main t
  visibility t
  events t .then -> t.end!

export default: main
