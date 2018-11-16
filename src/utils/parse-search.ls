function parse-search
  entries = new URLSearchParams it.replace /^\?/ '' .entries!
  Array.from entries .reduce (result, [name, value]) ->
    if name of result then result[name] := []concat result[name], value
    else result[name] := value
    result
  , {}

export default: parse-search
