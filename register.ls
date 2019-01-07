default-options =
  plugins:
    require.resolve \@babel/plugin-transform-modules-commonjs
    require.resolve \babel-plugin-livescript
    ...
  extensions: <[.ls .jsx .js]>

function register options={}
  require \livescript
  delete require.extensions\.ls
  option-list = [default-options, options]
  require \@babel/register <| Object.assign {} ...option-list,
    plugins: []concat ...option-list.map (.plugins || [])

module.exports = register
