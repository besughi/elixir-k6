defmodule K6.Template.PhoenixChannel do
  @moduledoc """
  Generates a phoenix channel template
  """
  use K6.Template

  @impl true
  def create(filename, opts) do
    url = Keyword.get(opts, :url, default_websocket_url())
    copy_template(template_path("phoenix-channel.js"), filename, url: url)
  end

  defp default_websocket_url do
    {host, port} = default_host_and_port()
    "ws://#{host}:#{port}/socket/websocket"
  end
end
