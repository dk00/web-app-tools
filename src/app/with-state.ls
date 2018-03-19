import
  \./react : {create-class, create-factory}
  \./utils : {flat-diff}

empty = {}
function name => it.display-name || it.name || it
function pass => it

function nested store
  listeners = new Set
  Object.assign {} store,
    subscribe: ->
      listeners.add it
      listeners.delete.bind listeners, it
    notify: -> Array.from listeners.keys! .map -> it!

!function init instance, select, render
  store = instance.props.store || instance.context.store
  context = store: next = if select != pass then nested store else store
  selected = select store.get-state!, instance.props
  changed = false

  function handle-change props=instance.props
    prev = selected
    selected := select store.get-state!, props
    if flat-diff prev, selected then changed := true else next.notify!

  handle-mount = if select != pass then component-did-mount: !->
    instance.component-will-unmount = store.subscribe ~>
      handle-change! && instance.set-state empty
  Object.assign instance, handle-mount,
    get-child-context: -> context
    component-will-receive-props: !->
      handle-change it if select != pass
      changed ||:= flat-diff instance.props, it
    should-component-update: -> changed
    render: ->
      changed := false
      render Object.assign {store.dispatch} selected

function chain select, render
  display-name: name render
  component-will-mount: !-> init @, select, render
  render: pass

function with-state select=pass => (component) ->
  create-class chain select, create-factory component

export default: with-state
