function delay t=1
  new Promise (resolve) -> set-timeout resolve, t

function animation-frame
  new Promise (resolve) -> request-animation-frame resolve

export {delay, animation-frame}
