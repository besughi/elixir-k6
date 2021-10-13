defmodule K6.Template.PhoenixChannel do
  @moduledoc """
  Generates a phoenix channel template
  """
  use K6.Template

  @impl true
  def create(filename, opts) do
    url = Keyword.get(opts, :url, default_websocket_url())
    create_file(filename, phoenix_channel_template(url: url))
  end

  defp default_websocket_url do
    {host, port} = default_host_and_port()
    "ws://#{host}:#{port}/socket/websocket"
  end

  embed_template(:phoenix_channel, """
  import Channel from "./utilities/phoenix-channel.js";
  import { sleep } from "k6";

  export default function () {
    let broadcastCallback = () => { }
    let channel = new Channel("<%= @url %>", "my_room:lobby", broadcastCallback);

    channel.join({}, () => {
      console.log("joined");

      channel.send("ping", { data: "content" }, (response) => {
        console.log(JSON.stringify(response));
        channel.send("ping", { data: "content" });
        channel.leave();
      });
    });
    sleep(1);
  }
  """)
end
