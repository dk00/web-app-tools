import '../utils': {local-date, input-datetime-string, server-date}

function wrap-target-value handler, wrap => (e) ->
  handler target: value: wrap e.target.value

function date-input-factory h, type=\date wrap-value=local-date =>
  ({value, on-change, on-input, ...props}) ->
    h \input Object.assign {type} props,
      value: wrap-value value
      if on-change then on-change: wrap-target-value on-change, server-date
      if on-input then on-input: wrap-target-value on-input, server-date

function datetime-input-factory h
  date-input-factory h, \datetime-local input-datetime-string

export {date-input-factory, datetime-input-factory}
