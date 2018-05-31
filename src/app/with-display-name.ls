function kebab-case
  it.replace /[a-z][A-Z]/, ([a, b]) -> "#{a}-#{b.to-lower-case!}"

function component-name
  name = it.display-name || it.name || it
  if name && \string == typeof name then name else \component

function with-display-name enhanced, base, modifier
  name = kebab-case component-name base
  enhanced.display-name = name + ':' + modifier
  enhanced

export default: with-display-name
