import path: {join}
import \./register : register
import \./babel-options : babel-options

base =
  entry: \./src/index
  resolve:
    extensions: <[.ls .jsx .js .sass .scss .yml .json]>
    alias:
      react: \preact-compat
      'react-dom': \preact-compat

function history-api-fallback app
  history = require \connect-history-api-fallback
  convert = require \koa-connect
  app.use convert history!

function development {base-plugins, output-path}
  config:
    output: public-path: \/
    plugins: base-plugins
    serve:
      content: output-path
      add: history-api-fallback
      #TODO Accept connection from anywhere, setting host here breaks websocket URL
  style-loader: [\style-loader]

function production {base-plugins, output-path, public-path}
  {DefinePlugin} = require \webpack
  MinifyPlugin = require \babel-minify-webpack-plugin
  {GenerateSW} = require \workbox-webpack-plugin

  config:
    output: {path: output-path, public-path}
    plugins:
      new DefinePlugin \module.hot : \false
      ...base-plugins
      new GenerateSW options =
        clients-claim: true
        skip-waiting: true
        navigate-fallback: public-path || '/'
    optimization:
      runtime-chunk: \single
      split-chunks:
        chunks: \all
        automatic-name-delimiter: \.
      minimizer: [new MinifyPlugin]
  style-loader:
    * * loader: \file-loader options: name: '[name].css'
      \extract-loader
  minimize: true

modes = {development, production}

function render-static entry, mode
  dummy-element =
    set-attribute: ->
    append-child: ->

  Object.assign global,
    document:
      query-selector: ->
      query-selector-all: -> []
      head: dummy-element
      createElement: -> dummy-element
      createTextNode: -> ''
    navigator: {}
    location: pathname: \/ host:
      if mode == \development then 'localhost' else ''
    render: -> render-static.result := it
    add-event-listener: ->

  register!
  require join process.cwd!, entry
  -> render-static.result

function create-html-plugin {mode, output-path, public-path='/' styles}
  HtmlPlugin = require \html-plugin
  {
    name: title='No Name'
    theme_color: theme-color
  } = (try require "#{output-path}/manifest.json") || {}
  html-options = Object.assign {},
    title: title, theme-color: theme-color
    prefix: public-path, content: render-static base.entry, mode
    manifest: "#{public-path}manifest.json"
    favicon: "#{public-path}favicon.png"
    if styles then {styles}
  new HtmlPlugin html-options

function get-config {production, p=production, output-public-path} config={}
  {mode, output: {public-path=output-public-path}={}} = config

  public-path: public-path
  mode:
    | mode => mode
    | p => \production
    | _ => \development

function config-generator {output-path=\www}: options={}
  (command-options, lib-config) ->
    {mode, public-path} = get-config command-options, lib-config
    base-options = {...options, mode, public-path, output-path: join process.cwd!, output-path}
    mode-options = Object.assign {} base-options,
      base-plugins: [create-html-plugin base-options]
    {config, style-loader, minimize} = modes[mode] mode-options
    rules =
      * use: loader: \babel-loader options: babel-options!
        test: /\.(ls|jsx|js)$/
        exclude: /node_modules/
      * test: /\.(sass|scss)$/
        use: []concat style-loader, <[css-loader sass-loader]>map ->
          loader: it, options: {url: false source-map: true minimize}

    Object.assign {mode, module: {rules}} base, config

export default: config-generator
