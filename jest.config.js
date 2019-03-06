module.exports = {
  coveragePathIgnorePatterns: [
    '.*'
  ],
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
    '\\.(js|jsx|ls)$': 'babel-jest'
  },
  transformIgnorePatterns: [
    '/node_modules/',
    '.pnp'
  ],
  setupFilesAfterEnv: [
    '<rootDir>/test/setup-tests.js'
  ]
}
