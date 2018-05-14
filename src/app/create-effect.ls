import
  \./react : {create-class}
  \./utils : {flat-diff, with-display-name}

common =
  shouldComponentUpdate: (next-props) -> flat-diff @props, next-props
  render: -> []concat @props.children .0

function try-unsubscribe props, unsubscribe => unsubscribe?!

function mount-effect me, set, clear
  Promise.resolve if me.unsubscribe
    clear me.props, me.unsubscribe
  .then -> set me.props
  .then -> me.unsubscribe = it

#TODO React 16 API
function create-effect set, clear=try-unsubscribe
  effect-container = create-class Object.assign {} common,
    componentDidMount: -> mount-effect @, set, clear
    componentDidUpdate: -> mount-effect @, set, clear
    componentWillUnmount: -> clear @props, @unsubscribe
  if process.env.NODE_ENV != \production
    effect-container.display-name = 'effect:' + set.name

  effect-container

export default: create-effect
