defmodule K6.Template.Liveview do
  @moduledoc """
  Generates a liveview template
  """
  use K6.Template

  @impl true
  def needs_utilities, do: ["phoenix-channel.js", "phoenix-liveview.js"]

  @impl true
  def create(filename, opts) do
    websocket_url = Keyword.get(opts, :url, default_websocket_url())
    http_url = http_url(websocket_url)

    copy_template(template_path("liveview.js"), filename,
      websocket_url: websocket_url,
      http_url: http_url
    )
  end

  defp default_websocket_url do
    {host, port} = default_host_and_port()
    "ws://#{host}:#{port}/live/websocket?vsn=2.0.0"
  end

  defp http_url(websocket_url) do
    uri = URI.parse(websocket_url)

    "http://#{uri.authority}/"
  end
end
