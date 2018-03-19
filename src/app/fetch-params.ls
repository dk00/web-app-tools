have-payload = PUT: true POST: true

function plain-object
  it && Object:: == Object.get-prototype-of it

function wrap-body
  if plain-object it then JSON.stringify it else it

function query-string params={} path=[]
  Object.entries params .filter (.1?) .map ([key, value]) ->
    current = path ++ key
    if typeof value == \object then query-string value, current
    else
      prefix = current.0 + current.slice 1 .map -> "[#it]"
      .join ''
      [prefix, value]map encodeURIComponent .join \=
  .filter (-> it) .join \&

function fetch-params url, {method=\GET parameters, params=parameters, data=params}
  #TODO default method to POST if FormData specified
  default-options = credentials: \include method
  [append, data-options] = if have-payload[method.to-upper-case!]
    * '' body: wrap-body data
  else [if query-string params then \? + that else '']
  * url + append, Object.assign {} default-options, data-options

export default: fetch-params
