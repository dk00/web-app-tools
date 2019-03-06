import
  path: {join}
  './register': register
  './babel-options': babel-options
  '../utils': {identity}

pnp-plugin = require \pnp-webpack-plugin

base =
  entry: './src/index'
  resolve:
    extensions: <[.ls .jsx .js .sass .scss .yml .json]>
    plugins: [pnp-plugin]
  resolve-loader: plugins: [pnp-plugin.module-loader module]

function js-rule mode
  loader: \babel-loader
  options: {babelrc: false, ...babel-options mode, true}
  test: /\.(ls|jsx|js)$/ exclude: /(node_modules|pnp)/

function css-rule mode
  mini-css = require \mini-css-extract-plugin
  dev = mode != \production
  options = url: false source-map: dev
  output-loader = if dev then \style-loader else mini-css.loader
  input-loaders = <[css-loader sass-loader]>map -> {loader: it, options}

  use: []concat output-loader, input-loaders
  test: /\.(sass|scss)$/

function base-plugins {mode, env, name, public-path='/', web-app}
  {EnvironmentPlugin} = require \webpack
  {GenerateWebApp} = require \pwa-utils
  web-app-options = Object.assign {name, public-path}, web-app,
    content: ''
  [].concat do
    if env then new EnvironmentPlugin env else []
    new GenerateWebApp web-app-options

function development options
  {HotModuleReplacementPlugin} = require \webpack

  mode: \development
  output: public-path: '/'
  module: rules: [js-rule!, css-rule!]
  cache: options.cache || {type: \filesystem}
  plugins:
    ...base-plugins options
    new HotModuleReplacementPlugin
  dev-server:
    hot: true
    content-base: options.output-path
    host: \0.0.0.0
    history-api-fallback: true

function sw-plugins options
  {exists-sync} = require \fs
  if exists-sync './src/service-worker.js'
    {InjectManifest} = require \workbox-webpack-plugin
    workbox-options = {sw-src: './src/service-worker.js', ...options}
    [new InjectManifest workbox-options]
  else []

function production {output-path, public-path, cache}: options
  {DefinePlugin} = require \webpack
  MiniCssExtractPlugin = require \mini-css-extract-plugin
  MinifyPlugin = require \terser-webpack-plugin

  mode: \production
  output: {path: output-path, public-path}
  module: rules: [js-rule \production; css-rule \production]
  cache: options.cache || {type: \filesystem}
  plugins:
    new DefinePlugin \module.hot : \false
    new MiniCssExtractPlugin chunk-filename: '[name].css'
    ...base-plugins options
    ...sw-plugins options.workbox
  optimization:
    runtime-chunk: \single
    split-chunks:
      chunks: \all
      automatic-name-delimiter: \.
      cache-groups: vendors:
        filename: \vendors.js
        test: /[\\/]node_modules[\\/]/
        priority: -10
    minimizer: [new MinifyPlugin]

modes = {development, production}

function mock-dom {mode}
  dummy-element =
    set-attribute: ->
    append-child: ->

  document:
    query-selector: ->
    query-selector-all: -> []
    head: dummy-element
    create-element: -> dummy-element
    create-text-node: -> ''
  navigator: {}
  location: new URL 'http://localhost'
  render: -> render-static.result := it
  add-event-listener: ->

function render-static {entry, mode}
  dom = mock-dom {mode}
  Object.assign global, dom, window: dom
  register!
  try require join process.cwd!, entry
  catch
    console.error e
    console.error 'Try to fix app for first render in node environment'
  -> render-static.result

function config-generator {output-path=\www env}: options={}
  (, {mode=\development}) ->
    base-options = {
      ...options, mode
      output-path: join process.cwd!, output-path
    }
    Object.assign {} base, modes[mode] base-options

export default: config-generator
