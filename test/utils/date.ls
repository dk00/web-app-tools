import '../../src/utils/date': {local-date, local-datetime, server-date}

function with-timezone offset, next
  Date::get-timezone-offset = -> offset
  next!

function main t
  with-timezone 480 ->
    actual = local-date '2018-08-01T07:00:00.000Z'
    expected = '2018-07-31'
    t.is actual, expected, 'date string in local timezone'

  with-timezone 120 ->
    actual = local-datetime '2018-08-01T07:00:00.000Z'
    expected = '2018-08-01 05:00'
    t.is actual, expected, 'datetime string in local timezone'

  actual = server-date '2018-08-01T07:00'
  expected = new Date '2018-08-01T07:00' .toJSON!
  t.is actual, expected, 'server datetime values ' + actual

  t.end!

export default: main
