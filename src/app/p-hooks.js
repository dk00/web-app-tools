import {options as n} from 'preact'

var t,
  r,
  u = [],
  f = n.render
n.render = function(n) {
  f && f(n), (t = 0), (r = n.__c).__H && (r.__H.n.forEach(_), (r.__H.n = []))
}
var i = n.diffed
n.diffed = function(n) {
  i && i(n)
  var t = n.__c
  if (t) {
    var r = t.__H
    r && (r.t.forEach(_), (r.t = []))
  }
}
var o = n.unmount
function e(n) {
  var t = r.__H || (r.__H = {r: [], n: [], t: []})
  return n >= t.r.length && t.r.push({}), t.r[n]
}
function c(n) {
  return a(h, n)
}
function a(n, u, f) {
  var i = e(t++)
  return (
    null == i.__c &&
      ((i.__c = r),
      (i.u = [
        null == f ? h(null, u) : f(u),
        function(t) {
          ;(i.u[0] = n(i.u[0], t)), i.__c.setState({})
        }
      ])),
    i.u
  )
}
function v(n, u) {
  var f = e(t++)
  E(f.f, u) && ((f.u = n), (f.f = u), r.__H.n.push(f), g(r))
}
function l(n, u) {
  var f = e(t++)
  E(f.f, u) && ((f.u = n), (f.f = u), r.__H.t.push(f))
}
function p(n) {
  var r = e(t++)
  return null == r.u && (r.u = {current: n}), r.u
}
function d(n, r) {
  var u = e(t++)
  return E(u.f, r) ? ((u.f = r), (u.i = n), (u.u = n())) : u.u
}
function s(n, t) {
  return d(function() {
    return n
  }, t)
}
function m(n) {
  var u = r.context[n.__c]
  if (null == u) return n.__p
  var f = e(t++)
  return null == f.u && ((f.u = !0), u.sub(r)), u.props.value
}
n.unmount = function(n) {
  o && o(n)
  var t = n.__c
  if (t) {
    var r = t.__H
    r &&
      r.r.forEach(function(n) {
        return n.o && n.o()
      })
  }
}
var y,
  g = function() {}
function w() {
  y.port1.postMessage(void 0)
}
function _(n) {
  n.o && n.o()
  var t = n.u()
  'function' == typeof t && (n.o = t)
}
function E(n, t) {
  return (
    null == n ||
    t.some(function(t, r) {
      return t !== n[r]
    })
  )
}

function h(n, t) {
  return 'function' == typeof t ? t(n) : t
}
'undefined' != typeof window &&
  ((y = new MessageChannel()),
  (g = function(n) {
    !n.e && (n.e = !0) && 1 === u.push(n) && requestAnimationFrame(w)
  }),
  (y.port2.onmessage = function() {
    u.forEach(function(n) {
      ;(n.e = !1), 1 && (n.__H.n.forEach(_), (n.__H.n = []))
    }),
      (u = [])
  }))
export {
  c as useState,
  a as useReducer,
  v as useEffect,
  l as useLayoutEffect,
  p as useRef,
  d as useMemo,
  s as useCallback,
  m as useContext
}
