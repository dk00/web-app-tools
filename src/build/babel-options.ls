function babel-options env=process.env.NODE_ENV
  plugins =
    require.resolve 'babel-plugin-livescript'
    * require.resolve '@babel/plugin-transform-react-jsx'
      pragma: \h pragma-frag: \fragment use-built-ins: true
    require.resolve 'babel-plugin-transform-component-name'
    if env != \production
      require.resolve \babel-plugin-dynamic-import-node
    if env == \production
      * require.resolve '@babel/plugin-transform-runtime'
        regenerator: false
    else
      * require.resolve \@babel/plugin-transform-modules-commonjs
        lazy: true
    if global.__coverage__
      require.resolve 'babel-plugin-istanbul'

  presets: [require.resolve 'babel-preset-upcoming']
  plugins: plugins.filter -> it
  generator-opts: jsesc-option: minimal: true

export default: babel-options
