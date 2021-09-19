defmodule K6.Utilities do
  @moduledoc """
  Utility functions for a k6 template
  """

  import Mix.Generator

  @spec generate(binary()) :: :ok
  def generate(path) do
    unless File.exists?(path) do
      create_directory(path)
      create_phoenix_channel(path)
    end

    :ok
  end

  defp create_phoenix_channel(path) do
    file_path = Path.join([path, "phoenix-channel.js"])
    create_file(file_path, phoenix_channel_template([]), force: true)
  end

  embed_template(:phoenix_channel, """
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
      ws.connect(this.url, {}, function (socket) {
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
        socket.on("close", () => { });
      }.bind(this));
    }

    send(event, payload, callback = () => { }) {
      this._send(event, payload, callback);
    }

    leave() {
      this.socket.close();
    }

    _send(event, payload, callback) {
      this.socket.send(JSON.stringify({
        topic: this.topic,
        event: event,
        payload: JSON.stringify(payload),
        ref: this.messageRef
      }));
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
  """)
end
