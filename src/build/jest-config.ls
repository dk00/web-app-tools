function jest-config {style-path=\style}={}
  coverage-path-ignore-patterns: ['.*']
  module-name-mapper: (style-path): 'web-app-tools'
  module-file-extensions: <[ls js jsx json]>
  resolver: require.resolve \jest-pnp-resolver
  test-match: ['**/*.test.(ls|js|jsx)']
  transform: '\\.(js|jsx|ls)$': \babel-jest
  transform-ignore-patterns:
    '/node_modules/'
    '.pnp'

export default: jest-config
