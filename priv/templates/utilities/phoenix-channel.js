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
          const data = JSON.parse(response);
          if (data.ref != null) {
            this.callbacks[data.ref](this._parsePayload(data.payload));
          } else {
            this.broadcastCallback(this._parsePayload(data.payload));
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
      JSON.stringify({
        topic: this.topic,
        event: event,
        payload: JSON.stringify(payload),
        ref: this.messageRef,
      })
    );
    this.callbacks[this.messageRef] = callback;
    this.messageRef += 1;
  }

  _parsePayload(payload) {
    try {
      return JSON.parse(payload.response);
    } catch (e) {
      return payload.response;
    }
  }
}
