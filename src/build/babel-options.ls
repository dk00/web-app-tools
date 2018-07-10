function babel-options {targets}={}
  presets: [\upcoming]
    #TODO replace babel-polyfill with polyfill.io
  plugins:
    \livescript
    * \@babel/transform-react-jsx pragma: \h use-built-in: true
    \transform-component-name

export default: babel-options
