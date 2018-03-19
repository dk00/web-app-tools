function babel-options {targets}={}
  presets: [\@babel/stage-0]concat if targets
    #TODO replace babel-polyfill with polyfill.io
    * * \@babel/env
        {targets, use-built-ins: \usage modules: false debug: true}
      ...
  else []
  plugins:
    \livescript
    * \@babel/transform-react-jsx pragma: \h use-built-in: true
    \transform-component-name

export default: babel-options
