import
  'preact-testing-library': {render, fire-event, cleanup}
  './utils': {animation-frame}
  '../src/app/stack-provider': stack-provider
  '../src/app/react': {h}
  '../src/app/routing': {route, nav-link}

after-each cleanup

function sample-element
  h stack-provider, {},
    h route, path: '/' render: -> h \div,, \home
    h route, path: '/first' render: ->
      h \div,, \first
    h nav-link, {to: '/first' others: class-name: \anchor} \to1

describe \Routing !->
  test 'Given initial state, should render only matched components' ->
    {query-all-by-text} = render sample-element!

    home = query-all-by-text \home
    expect home.length .to-be 1
    first = query-all-by-text \first
    expect first.length .to-be 0

  test 'Given navigating to some view, should render only matched components' ->
    element = sample-element!
    {get-by-text, query-all-by-text, rerender} = render element

    await animation-frame!

    fire-event.click get-by-text \to1
    await animation-frame!

    match-count = query-all-by-text \first .length
    expect match-count .to-be 1

    anchor-class = get-by-text \to1 .class-name
    expect anchor-class .to-be 'anchor active'
