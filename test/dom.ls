import
  '../src/app/dom': {on: add-event-listener, till, passive}

function main t
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

    t.end!

export default: main
