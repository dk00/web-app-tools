import \./fetch-params : fetch-params

function fetch-object path, options
  fetch ...fetch-params path, options .then (.json!)

export default: fetch-object
