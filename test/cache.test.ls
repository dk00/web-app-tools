import
  'preact-testing-library': {render, fire-event, cleanup}
  './utils': {animation-frame}
  '../src/app/react': {h}
  '../src/app/stack-provider': stack-provider
  '../src/app/store': {use-store-state}
  '../src/app/cache': {
    use-shared-state, reduce-entities
    get-document, get-collection
    update-document, replace-collection
  }

after-each cleanup

function sample
  [state, set-state] = use-shared-state \test, \initial
  change = -> set-state \changed

  h \div,,
    h \div,, state || 'no value'
    h \button, on-click: change, \change

describe 'Shared state' !->
  test 'Given components using shared state, should render correctly' ->
    {get-by-text, container, query-all-by-text} = render h stack-provider,, h sample

    await animation-frame!

    initial = query-all-by-text \initial
    expect initial.length .to-be 1

    fire-event.click get-by-text \change

    await animation-frame!

    changed = query-all-by-text \changed
    expect changed.length .to-be 1

describe 'Cache actions' !->
  test 'Given update-document action with empty state, should create it' ->
    entities = reduce-entities {} update-document values: test: 1
    result = get-document {entities}
    expect result .to-equal test: 1

  test 'Given replace-collection action with empty state, should add to state' ->
    entities = reduce-entities {} replace-collection type: \test documents:
      * id: 2 name: \doc-2
      * id: 3 name: \doc-3

    result = get-collection {entities} type: \test
    expect result .to-equal documents: [2 3] by-id:
      2: id: 2 name: \doc-2
      3: id: 3 name: \doc-3
