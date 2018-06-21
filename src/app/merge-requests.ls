function merge-requests requests, {prefix='/'}={}
  requests.map -> path: prefix + it.collection, data: {}

export default: merge-requests
