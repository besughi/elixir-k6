defmodule K6.Template.Rest do
  @moduledoc """
  Generates a rest template
  """
  use K6.Template

  @impl true
  def create(filename, opts) do
    url = Keyword.get(opts, :url, default_rest_base_url())
    copy_template(template_path("rest.js"), filename, url: url)
  end

  defp default_rest_base_url do
    {host, port} = default_host_and_port()
    "http://#{host}:#{port}"
  end
end
