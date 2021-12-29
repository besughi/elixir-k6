import ws from "k6/ws";
import { URL } from "https://jslib.k6.io/url/1.0.0/index.js";

export default class Channel {
  constructor(url, topic, params, broadcastCallback) {
    this.url = new URL(url);
    this.topic = topic;
    this.params = params;
    this.broadcastCallback = broadcastCallback;
    this.callbacks = {};
    this.sent_messages = {};
    this.messageRef = 5;
    this.joinRef = 5; // TODO make it dynamic?

    this.url.searchParams.append("vsn", "2.0.0");
  }

  join(payload, callback) {
    return ws.connect(
      this.url.toString(),
      this.params,
      function (socket) {
        this.socket = socket;
        socket.on("open", () => this._send("phx_join", payload, callback));
        socket.on("message", (response) => {
          const message = this._parseMessage(response);

          if (message.ref != null) {
            this.callbacks[message.ref.toString()](message);
          } else {
            this.broadcastCallback(message);
          }
        });
        socket.on("close", () => {});
      }.bind(this)
    );
  }

  leave() {
    this.socket.close();
  }

  setInterval(callback, interval) {
    return this.socket.setInterval(callback, interval);
  }

  setTimeout(callback, period) {
    return this.socket.setTimeout(callback, period);
  }

  send(event, payload, callback = () => {}) {
    this._send(event, payload, callback);
  }

  _send(event, payload, callback) {
    let message = JSON.stringify([
      this.joinRef.toString(),
      this.messageRef.toString(),
      this.topic,
      event,
      payload,
    ]);

    this.socket.send(message);

    this.callbacks[this.messageRef.toString()] = callback;
    this.messageRef += 1;
  }

  _parseMessage(message) {
    let [joinRef, msgRef, topic, event, payload] = JSON.parse(message);
    return {
      joinRef: joinRef,
      ref: msgRef,
      topic: topic,
      event: event,
      payload: payload,
    };
  }
}