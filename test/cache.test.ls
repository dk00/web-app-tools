import
  'react-testing-library': {render, fire-event, cleanup}
  './utils': {delay}
  '../src/app/react': {h}
  '../src/app/stack-provider': stack-provider
  '../src/app/cache': {use-shared-state}
  '../src/app/store': {use-store-state}

after-each cleanup

function sample
  [state, set-state] = use-shared-state \test, \initial
  change = -> set-state \changed

  h \div,,
    h \div,, state || 'no value'
    h \button, on-click: change, \change

describe 'Shared state' ->
  test 'Given components using shared state, should render correctly' ->
    {get-by-text, container, query-all-by-text} = render h stack-provider,, h sample

    await delay 1

    initial = query-all-by-text \initial
    expect initial.length .to-be 1

    fire-event.click get-by-text \change

    await delay 1

    changed = query-all-by-text \changed
    expect changed.length .to-be 1
