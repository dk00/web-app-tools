import
  'preact-testing-library': {render, fire-event, cleanup}
  './utils': {animation-frame, delay}
  '../src/app/stack-provider': stack-provider
  '../src/app/react': {h}
  '../src/app/routing': {route, nav-link}

after-each cleanup

function sample-element
  h stack-provider, {},
    h route, path: '/' render: -> h \div,, \home
    h route, path: '/first' render: ->
      h \div,, \first
    h nav-link, {to: '/first' class-name: \anchor} \to1

function props-to-element {handle-props}
  h stack-provider, {},
    h route, path: '/:type/:id', render: (props) ->
      handle-props props
      h \div,, \whatever
    h nav-link, to: '/data/2', \go

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

  test 'Given a route, should pass correct props to matched components' ->
    props = {}
    {get-by-text} = render props-to-element handle-props: ->
      props := it
    await animation-frame!

    fire-event.click get-by-text \go
    await animation-frame!

    expect props.match.params .to-equal type: \data id: \2
