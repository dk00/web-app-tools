import \./babel-options : babel-options

default-options =
  plugins: [\@babel/transform-modules-commonjs]
  extensions: <[.ls .jsx .js]>

function nop =>

function ignore-extensions
  it.for-each -> require.extensions[it] = nop

function register options={}
  try
    require \livescript
    delete require.extensions\.ls
  ignore-extensions <[.css .sass .scss]>
  option-list = [default-options, babel-options!, options]
  require \@babel/register <| Object.assign {} ...option-list,
    plugins: []concat ...option-list.map (.plugins || [])

export default: register
