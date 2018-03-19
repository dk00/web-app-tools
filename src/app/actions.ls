import redux: {combine-reducers}

function handle-actions handlers, default-state={}
  (state, {type, payload}) ->
    if handlers[type]? state, payload then Object.assign {} state, that
    else state || default-state

function compose-reduce reducers
  wrapped = Object.entries reducers .map ([key, reduce]) ->
    (key): if typeof reduce == \function then reduce
    else handle-actions reduce
  combine-reducers Object.assign ...wrapped

export {handle-actions, compose-reduce}
