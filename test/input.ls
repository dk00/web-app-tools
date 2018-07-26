import '../src/app/input': {date-input-factory, datetime-input-factory}

function element-meta type, props, ...children
  {type, props, children}

function main t
  result = void
  date-input = date-input-factory element-meta

  {type, props: input} = date-input value: '2018-08-01' on-change: ->
    result := it.target.value

  actual = type
  expected = \input
  t.is actual, expected, 'component / element type'

  actual = input.value.match /^\d{4}-\d{2}-\d{2}$/
  t.ok actual, 'convert to date strings work with builtin input ' + value

  input.on-change target: value: '2018-08-01'

  actual = result.length
  expected = 24
  t.is actual, expected,
    'pass converted date string to event handlers ' + result

  {props: another} = date-input value: '2018-08-01' on-input: ->

  actual = \onInput of input or \onChange of another
  t.false actual, 'only attach specified event handlers'

  datetime-input = datetime-input-factory element-meta
  {type, props: {value}} = datetime-input value: '2018-08-01T05:00:00.000Z'

  actual = value.match /^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}$/
  t.ok actual, 'convert to datetime strings work with builtin input ' + value

  t.end!

export default: main
