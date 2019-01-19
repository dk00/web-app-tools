function delay t=1
  new Promise (resolve) -> set-timeout resolve, t

export {delay}
