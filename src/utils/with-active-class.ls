function with-active-class props
  Object.assign {} props, class:
    (props.class || '')split ' ' .concat \active  .join ' '

export default: with-active-class