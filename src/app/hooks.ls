import
  './p-hooks': {
    use-state, use-reducer, use-context, use-effect: use-effect-o
    use-memo, use-callback, use-ref
  }

function use-effect fn, args
  use-effect-o fn, switch
  | !args => [[]]
  | args.length == 0 => [0]
  | _ => args

export {use-state, use-reducer, use-effect, use-ref}
export {use-context, use-memo, use-callback}
