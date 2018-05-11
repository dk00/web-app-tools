function merge-exclusive a, b
  if !Object.keys b .some (of a) then b
  else
    merged = Object.entries b .map ([key, value]) ->
      (key): deep-merge a[key], value
    Object.assign ...merged

function is-object => it && Object:: == Object.get-prototype-of it
function deep-merge a, b
  if !is-object a or !is-object b then b
  else Object.assign {} a, merge-exclusive a, b

export default: deep-merge
