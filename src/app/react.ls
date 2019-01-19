import
  react: {create-element: h, Fragment, create-context, memo}
  'react-dom': {render}

function should-wrap => typeof it == \string || it.hooks || it::?render

function create-factory component
  if should-wrap component then ({children, ...props}) ->
    h component, props, children
  else component

export {create-factory}
export {h, fragment: Fragment, render, create-context, memo}
