import
  'preact-testing-library': {render, fire-event, cleanup}
  './utils': {animation-frame}
  '../src/app/react': {h}
  '../src/app/stack-provider': stack-provider
  '../src/app/store': {use-store-state}
  '../src/app/cache': {
    use-shared-state, reduce-entities, add-to-end, remove-documents
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

describe 'Collection selectors' !->
  test 'Given empty state to getCollection, should return empty collection' ->
    result = get-collection {} type: \whatever
    expect typeof result .to-be \object

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

  test 'Given add-to-end action, should add documents to end of the collection' ->
    actions =
      add-to-end type: \test documents:
        * id: 2 name: \doc-2
        * id: 3 name: \doc-3
      add-to-end type: \test documents: [id: 5 name: \doc-5]

    entities = actions.reduce reduce-entities, {}

    result = get-collection {entities} type: \test
    expect result .to-equal documents: [2 3 5] by-id:
      2: id: 2 name: \doc-2
      3: id: 3 name: \doc-3
      5: id: 5 name: \doc-5

  test 'Given remove-documents action, should remove documents from the collection' ->
    actions =
      replace-collection type: \test documents:
        * id: 2 name: \doc-2
        * id: 3 name: \doc-3
        * id: 5 name: \doc-5
        * id: 7 name: \doc-7
      remove-documents type: \test documents: [3 7]

    entities = actions.reduce reduce-entities, {}

    result = get-collection {entities} type: \test
    expect result.documents .to-equal [2 5]
