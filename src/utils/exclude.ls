function exclude items, existing, key
  remove = Object.assign ...existing.map -> (key it): true
  items.filter -> !remove[key it]

export default: exclude
