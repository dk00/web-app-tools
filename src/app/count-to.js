import {h, createClass} from './react'

const step = (target, current, duration=16) => {
  const sign = Math.sign(target - current)
  const slice = Math.round(Math.abs(target - current)/duration)
  return sign + sign*slice
}

const startCount = instance => {
  const {props: {value=0, class: name}, state: {value: current=0}} = instance
  const target = /active/.test(name)? value: 0
  const delta = step(target, current)
  if (delta != 0 && !instance.request)
    instance.request = requestAnimationFrame(() => {
      instance.request = void 7
      instance.setState(({value=0}) => ({value: value + delta, delta}))
    })
}

const countTo = createClass({
  componentDidMount() {
    startCount(this)
  },
  componentDidUpdate() {
    startCount(this)
  },
  render() {
    return h('span', {ref: this.props.setRef}, this.state?.value || 0)
  }
})

export default countTo
