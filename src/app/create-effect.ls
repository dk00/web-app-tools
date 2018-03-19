import
  \./react : {create-class}
  \./utils : {flat-diff}

common =
  shouldComponentUpdate: (next-props) -> flat-diff @props, next-props
  render: -> []concat @props.children .0

function try-unsubscribe props, unsubscribe => unsubscribe?!

#TODO React 16 API
function create-effect set, clear=try-unsubscribe
  create-class Object.assign {} common,
    componentDidMount: -> set @props
    componentDidUpdate: ->
      clear @props, @unsubscribe
      @unsubscribe = set @props
    componentWillUnmount: -> clear @props, @unsubscribe

export default: create-effect
