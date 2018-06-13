function parse-search
  entries = new URLSearchParams it.replace /^\?/ '' .entries!
  Object.assign {} ...Array.from entries, ([name, value]) ->
    (name): value

export default: parse-search
