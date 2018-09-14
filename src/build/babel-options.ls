function babel-options {targets, runtime=true}={}
  presets: [\upcoming]
    #TODO replace babel-polyfill with polyfill.io
  plugins:
    \livescript
    ...if runtime then
      [[\@babel/transform-runtime use-ES-modules: true regenerator: false]]
    else []
    * \@babel/transform-react-jsx pragma: \h use-built-in: true
    \transform-component-name
  generator-opts: jsesc-option: minimal: true

export default: babel-options
