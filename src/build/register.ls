import \./babel-options : babel-options

default-options =
  plugins: [\@babel/transform-modules-commonjs]
  extensions: <[.ls .jsx .js .sass .scss .json]>

function register options={}
  try
    require \livescript
    delete require.extensions\.ls
  option-list = [default-options, babel-options!, options]
  require \@babel/register <| Object.assign {} ...option-list,
    plugins: []concat ...option-list.map (.plugins || [])

export default: register
