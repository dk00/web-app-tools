function request-key {path, data={}}
  path + ' ' + JSON.stringify data

export default: request-key
