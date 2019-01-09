import
  '../src/build/story': story
  '../src/build/babel-transform': transform

story 'Jest does not handle our babel config correctly, so we write a transform function' ->
  code = 'a b'
  it {
    given: 'source code'
    should: 'transpile with babel'
    actual: transform.process code, \sample.ls .split /\s+/ .2
    expected: 'a(b);'
  }
