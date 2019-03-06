function MessageChannel() {
  const port2 = {}
  this.port2 = port2
  this.port1 = {
    postMessage: () => port2.onmessage()
  }
}

global.MessageChannel = MessageChannel
