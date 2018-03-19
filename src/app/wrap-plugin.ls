import
  \./react : {h, create-class}
  \./dom : {require-scripts, remove-children}

common =
  shouldComponentUpdate: -> false
  componentWillUnmount: -> remove-children @node

function wrap-plugin {styles, scripts, attach}
  load-bundles = void
  create-class Object.assign display-name: attach.name, common,
    componentWillMount: -> load-bundles ||:= require-scripts scripts
    componentDidMount: -> load-bundles.then ~> attach @node, @props
    componentWillReceiveProps: ->
      #TODO replace with componentDidUpdate... or shouldComponentUpdate?
      load-bundles.then ~>
        remove-children @node
        attach @node, @props
    render: -> h \div class: styles, ref: ~> @node := it

export default: wrap-plugin
