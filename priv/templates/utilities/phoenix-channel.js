import ws from "k6/ws";

export default class Channel {
  constructor(url, topic, broadcastCallback) {
    this.url = url;
    this.topic = topic;
    this.broadcastCallback = broadcastCallback;
    this.callbacks = {};
    this.messageRef = 0;
  }

  join(payload, callback) {
    ws.connect(
      this.url,
      {},
      function (socket) {
        this.socket = socket;
        socket.on("open", () => this._send("phx_join", payload, callback));
        socket.on("message", (response) => {
          const message = this._parseMessage(response);
          if (message.ref != null) {
            this.callbacks[message.ref](message);
          } else {
            this.broadcastCallback(message);
          }
        });
        socket.on("close", () => {});
      }.bind(this)
    );
  }

  send(event, payload, callback = () => {}) {
    this._send(event, payload, callback);
  }

  leave() {
    this.socket.close();
  }

  _send(event, payload, callback) {
    this.socket.send(
      JSON.stringify([null, this.messageRef, this.topic, event, payload])
    );
    this.callbacks[this.messageRef] = callback;
    this.messageRef += 1;
  }

  _parseMessage(message) {
    let [joinRef, msgRef, topic, event, payload] = JSON.parse(message);
    return { joinRef, ref: msgRef, topic, event, payload };
  }
}
