function babel-options
  presets: [require.resolve 'babel-preset-upcoming']
  plugins:
    require.resolve 'babel-plugin-livescript'
    * require.resolve '@babel/plugin-transform-react-jsx'
      pragma: \h pragma-frag: \fragment use-built-ins: true
    require.resolve 'babel-plugin-transform-component-name'
    * require.resolve '@babel/plugin-transform-runtime'
      regenerator: false
  generator-opts: jsesc-option: minimal: true

export default: babel-options
