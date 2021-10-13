defmodule K6.Template.WebSocket do
  @moduledoc """
  Generates a websocket template
  """
  use K6.Template

  @impl true
  def create(filename, opts) do
    url = Keyword.get(opts, :url, default_websocket_url())
    copy_template(template_path("websocket.js"), filename, url: url)
  end

  defp default_websocket_url do
    {host, port} = default_host_and_port()
    "ws://#{host}:#{port}/"
  end
end
