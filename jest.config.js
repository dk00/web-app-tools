module.exports = {
  clearMocks: true,
  coverageDirectory: 'coverage',
  moduleFileExtensions: [
    'ls',
    'js',
    'jsx',
    'json'
  ],
  resolver: require.resolve('jest-pnp-resolver'),
  testMatch: [
    '**/*.test.(ls|js|jsx)'
  ],
  transform: {
    '\\.(ls|js|jsx)$': './babel-transform'
  }
}
