function local-date-json
  local = new Date it
  local.set-minutes local.get-minutes! - local.get-timezone-offset!
  local.toJSON!

function server-date => new Date it .toJSON!

function local-date => local-date-json it ?.slice 0 10
function local-datetime
  local-date-json it .slice 0 16 .replace 'T' ' '

function input-datetime-string => local-date-json it .slice 0 16

export {local-date, local-datetime}
export {local-date-json, input-datetime-string, server-date}
