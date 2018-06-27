import
  '../src/app/with-effect': with-effect
  './mock': {render-once, set-props, unmount}

function main t
  result = void
  context = void
  child-props = void
  apply-effect = (props-list, c) ->
    result := props-list
    context := c
  render-child = ->
    child-props := it
    value: \dummy
  product = with-effect apply-effect <| render-child

  props = value: 1
  first = render-once product, {props, context: \context}

  actual = result.map (.value) .join ' '
  expected = \1
  t.is actual, expected, 'apply single effect'

  actual = context.store
  t.ok actual, 'also pass context to effect'

  actual = child-props
  expected = value: 1
  t.same actual, expected, 'pass props to wrapped components'

  props = value: 2
  render-once product, {props}

  actual = result.map (.value) .join ' '
  expected = '1 2'
  t.is actual, expected, 'apply additional effects after mounting components'

  set-props first, value: 3

  actual = result.map (.value) .join ' '
  expected = '3 2'
  t.is actual, expected, 'apply effects after component props update'

  unmount first

  actual = result.map (.value) .join ' '
  expected = \2
  t.is actual, expected, 'apply effects with props removed when unmounting'

  t.end!

export default: main
