import '../src/utils': {parse-search}

function main t
  t {
    given: 'query string with duplicated keys'
    should: 'pack it into array'
    actual: parse-search 'a=1&a=2' .a.join ' '
    expected: '1 2'
  }
  Promise.resolve!

export default: main
