import \../src/utils : {deep-merge}

function main t
  actual = deep-merge {a: b: 2} a: c: 0
  expected = a: b: 2 c: 0
  t.same actual, expected, 'merge inner objects'

  actual = deep-merge {a: value: 'should replace'} a: \base-type
  expected = a: \base-type
  t.same actual, expected, 'replace object with base type values'

  t.end!

export default: main
