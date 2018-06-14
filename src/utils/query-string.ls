function expand-entries data
  parameters = Object.entries data .map ([key, value]) ->
    if value && typeof value == \object
      expand-entries value .map ({key: sub, value: sub-value}) ->
        key: [key]concat sub
        value: sub-value
    else {key, value}
  []concat ...parameters

function query-key key
  [first, ...rest] = []concat key
  [first]concat rest.map -> "[#it]"
  .join ''

function add-entries params, data
  expand-entries data .for-each ({key, value}) ->
    params.set (query-key key), value
  params

function query-string data
  p = new URLSearchParams
  add-entries p, data
  p.to-string!

export default: query-string
