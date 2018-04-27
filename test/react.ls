import \../src/app/react : {create-class}

function main t
  self = false
  passed-props = false
  props = value: \props
  component = create-class constructor: (props) !->
    self := @
    passed-props := props

  actual = [new component props; passed-props]
  expected = [self, props]
  t.same actual, expected, 'call specified constructor with props'

  t.end!

export default: main
