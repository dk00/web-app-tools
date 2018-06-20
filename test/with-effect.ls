import
  '../src/app/with-effect': with-effect
  './mock': {render-once, set-props, unmount}

function main t
  result = void
  merge-props = -> it
  apply-effect = -> result := it
  product = with-effect merge-props, apply-effect <| -> value: \dummy

  props = value: 1
  first = render-once product, {props}

  actual = result.map (.value) .join ' '
  expected = \1
  t.is actual, expected, 'apply single effect'

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
