function api-url options: {base-url, collections}, id
  collections?[id] || base-url + id

export {api-url}
