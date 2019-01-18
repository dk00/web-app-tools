import '../src/build/babel-transform': transform

describe 'Jest does not handle our babel config correctly, so we write a transform function' ->
  test 'Given source code, should transpile with babel'  ->
    code = 'a b'
    result = transform.process code, \sample.ls .includes 'a(b);'
    expect result .to-be true
