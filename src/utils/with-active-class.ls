function with-active-class props
  Object.assign {} props, class:
    (props.class || props.class-name || '')split ' ' .concat \active  .join ' '

export default: with-active-class
