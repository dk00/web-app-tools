import
  './with-display-name' : with-display-name
  './react': {h, create-class, create-factory}

function empty => ''

function async-component load-component, placeholder=empty
  async-component = create-class do
    display-name: \async-component
    component-did-mount: ->
      load-component!then ~>
        @render = create-factory it.default
        @set-state loaded: true
    render: create-factory placeholder
  if process.env.NODE_ENV != \production
    return with-display-name with-effect, component, \async-component
  async-component

export default: async-component