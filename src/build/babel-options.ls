function babel-options {targets}={}
  plugins:
    require.resolve '@babel/plugin-proposal-function-bind'
    require.resolve '@babel/plugin-proposal-do-expressions'
    require.resolve '@babel/plugin-proposal-export-default-from'
    [require.resolve '@babel/plugin-proposal-nullish-coalescing-operator'; loose: true]
    [require.resolve '@babel/plugin-proposal-optional-chaining'; loose: true]
    [require.resolve '@babel/plugin-proposal-pipeline-operator'; proposal: \minimal]
    require.resolve '@babel/plugin-proposal-export-namespace-from'
    require.resolve '@babel/plugin-proposal-function-sent'
    require.resolve '@babel/plugin-proposal-numeric-separator'
    require.resolve '@babel/plugin-proposal-throw-expressions'
    require.resolve '@babel/plugin-proposal-async-generator-functions'
    [require.resolve '@babel/plugin-proposal-object-rest-spread'; use-built-ins: true]
    require.resolve '@babel/plugin-proposal-optional-catch-binding'
    require.resolve '@babel/plugin-proposal-unicode-property-regex'
    require.resolve '@babel/plugin-syntax-dynamic-import'
    require.resolve '@babel/plugin-syntax-import-meta'
    require.resolve 'babel-plugin-livescript'
    [require.resolve '@babel/plugin-transform-react-jsx'; pragma: \h pragma-frag: \Fragment use-built-ins: true]
    require.resolve 'babel-plugin-transform-component-name'
  generator-opts: jsesc-option: minimal: true

export default: babel-options
