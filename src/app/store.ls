import
  redux: {create-store, combine-reducers}
  '../utils': {flat-diff, identity}
  './react': {h, create-context}
  './hooks': {use-state, use-effect, use-ref, use-context}

store-context = create-context {}

function handle-actions handlers, default-state={}
  (state, {type, payload}) ->
    if handlers[type]? state, payload then Object.assign {} state, that
    else state || default-state

function compose-reduce reducers
  wrapped = Object.entries reducers .map ([key, reduce]) ->
    (key): if typeof reduce == \function then reduce
    else handle-actions reduce
  Object.assign ...wrapped

function store-provider {reducer={} initial-state={} actions=[] init, children}
  final-reducer = combine-reducers compose-reduce reducer
  state = []concat type: \INIT, actions .reduce final-reducer, initial-state
  store = create-store final-reducer, state, window?__REDUX_DEVTOOLS_EXTENSION__?!
  init? store.replace-reducer
  h store-context.Provider, value: store, children

function use-store => use-context store-context

function use-store-state selector, props
  store = use-store!
  own-props = use-ref use-store
  derived-state = use-ref!
  [, notify-update] = use-state!
  if flat-diff props, own-props.current
    own-props.current := props
    derived-state.current := selector store.get-state!, own-props.current
  setup = ->
    handle-changes = ->
      prev = derived-state.current
      derived-state.current := selector store.get-state!, own-props.current
      if flat-diff prev, derived-state.current
        notify-update []
    un = store.subscribe handle-changes
    ->
      handle-changes := identity
      un!
  use-effect setup, []
  derived-state.current

export {store-provider, use-store, use-store-state}
