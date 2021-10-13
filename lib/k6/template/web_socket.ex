defmodule K6.Template.WebSocket do
  @moduledoc """
  Generates a websocket template
  """
  use K6.Template

  @impl true
  def create(filename, opts) do
    url = Keyword.get(opts, :url, default_websocket_url())
    create_file(filename, websocket_template(url: url))
  end

  defp default_websocket_url do
    {host, port} = default_host_and_port()
    "ws://#{host}:#{port}/"
  end

  embed_template(:websocket, """
  import ws from 'k6/ws';
  import { check } from 'k6';

  export default function () {
    const url = '<%= @url %>';
    const params = { tags: { my_tag: 'hello' } };

    const res = ws.connect(url, params, function (socket) {
      socket.on('open', () => console.log('connected'));
      socket.on('message', (data) => console.log('Message received: ', data));
      socket.on('close', () => console.log('disconnected'));
    });

    check(res, { 'status is 101': (r) => r && r.status === 101 });
  }
  """)
end
