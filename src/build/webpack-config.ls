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

function base-plugins {mode, env, public-path='/', web-app}
  {EnvironmentPlugin} = require \webpack
  {GenerateWebApp} = require \pwa-utils
  web-app-options = Object.assign {public-path}, web-app,
    content: render-static {base.entry, mode}
  [].concat do
    if env then new EnvironmentPlugin env else []
    new GenerateWebApp web-app-options

function development options
  {HotModuleReplacementPlugin} = require \webpack

  mode: \development
  output: public-path: '/'
  module: rules: [js-rule!, css-rule mode: \development]
  plugins:
    ...base-plugins options
    new HotModuleReplacementPlugin
  dev-server:
    hot: true
    content-base: options.output-path
    host: \0.0.0.0
    history-api-fallback: true

function production {output-path, public-path, workbox}: options
  {DefinePlugin} = require \webpack
  MinifyPlugin = require \terser-webpack-plugin
  {GenerateSW} = require \workbox-webpack-plugin

  mode: \production
  output: {path: output-path, public-path}
  module: rules: [js-rule!, css-rule!]
  plugins:
    new DefinePlugin \module.hot : \false
    ...base-plugins options
    new GenerateSW {
      clients-claim: true
      skip-waiting: true
      navigate-fallback: public-path || '/'
      ...workbox
    }
  optimization:
    runtime-chunk: \single
    split-chunks:
      chunks: \all
      automatic-name-delimiter: \.
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

function get-config {production, p=production, 'output-public-path': public-path}
  public-path: public-path
  mode: if p then \production else \development

function config-generator {output-path=\www env}: options={} => ->
  mode = process.env.NODE_ENV || \development
  base-options = {
    ...options, mode
    output-path: join process.cwd!, output-path
  }
  Object.assign {} base, modes[mode] base-options

export default: config-generator
