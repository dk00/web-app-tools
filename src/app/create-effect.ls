import
  \./react : {create-class}
  \./utils : {flat-diff, with-display-name}

common =
  shouldComponentUpdate: (next-props) -> flat-diff @props, next-props
  render: -> []concat @props.children .0

function try-unsubscribe props, unsubscribe => unsubscribe?!

#TODO React 16 API
function create-effect set, clear=try-unsubscribe
  effect-container = create-class Object.assign {} common,
    componentDidMount: -> set @props
    componentDidUpdate: ->
      clear @props, @unsubscribe
      @unsubscribe = set @props
    componentWillUnmount: -> clear @props, @unsubscribe
  if process.env.NODE_ENV != \production
    effect-container.display-name = 'effect:' + set.name

  effect-container

export default: create-effect
