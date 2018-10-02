import './shared': {identity}

function exclude items, existing, key=identity
  remove = Object.assign {} ...existing.map -> (key it): true
  items.filter -> !remove[key it]

export default: exclude
