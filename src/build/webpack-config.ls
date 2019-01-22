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

function js-rule
  loader: \babel-loader options: babel-options!
  test: /\.(ls|jsx|js)$/
  exclude: /node_modules/

function css-rule {mode}={}
  mini-css = require \mini-css-extract-plugin
  dev = mode == \development
  options = url: false source-map: dev, minimize: !dev
  output-loader = if dev then \style-loader else mini-css.loader
  input-loaders = <[css-loader sass-loader]>map -> {loader: it, options}

  use: []concat output-loader, input-loaders
  test: /\.(sass|scss)$/

function base-plugins {mode, env, public-path='/', sw, web-app}
  {EnvironmentPlugin} = require \webpack
  {GenerateWebApp} = require \pwa-utils
  [].concat do
    if env then new EnvironmentPlugin env else []
    if sw then []
    else
      web-app-options = Object.assign {public-path}, web-app,
        content: render-static {base.entry, mode}
      new GenerateWebApp web-app-options

function development options
  {HotModuleReplacementPlugin} = require \webpack

  mode: \development
  output: public-path: '/'
  module: rules: [js-rule!, css-rule mode: \development]
  cache: options.cache || {type: \filesystem}
  plugins:
    ...base-plugins options
    new HotModuleReplacementPlugin
  dev-server:
    hot: true
    content-base: options.output-path
    host: \0.0.0.0
    history-api-fallback: true

function production {output-path, public-path, sw, cache}: options
  {DefinePlugin} = require \webpack
  MinifyPlugin = require \terser-webpack-plugin

  mode: \production
  output: {
    path: output-path, public-path
    ...(sw && filename: 'service-worker.js')
  }
  module: rules: [js-rule!, css-rule!]
  cache: options.cache || {type: \filesystem}
  plugins:
    new DefinePlugin \module.hot : \false
    ...base-plugins options
  optimization: if sw
    runtime-chunk: false
    split-chunks: false
    minimizer: [new MinifyPlugin]
  else
    runtime-chunk: \single
    split-chunks:
      chunks: \all
      automatic-name-delimiter: \.
      cacheGroups: vendors:
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

function config-generator {output-path=\www env, sw}: options={}
  (, {mode=\development}) ->
    base-options = {
      ...options, mode, sw: false
      output-path: join process.cwd!, output-path
    }
    main = Object.assign {} base, modes[mode] base-options
    sw-config = if sw
      Object.assign {} base, entry: sw, modes[mode] {...base-options, sw: true}
    else []

    []concat main, sw-config

export default: config-generator
