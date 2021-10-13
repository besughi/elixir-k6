defmodule K6.Template.Graphql do
  @moduledoc """
  Generates a graphql template
  """
  use K6.Template

  @impl true
  def create(filename, opts) do
    url = Keyword.get(opts, :url, default_graphql_base_url())
    copy_template(template_path("graphql.js"), filename, url: url)
  end

  defp default_graphql_base_url do
    {host, port} = default_host_and_port()
    "http://#{host}:#{port}"
  end
end
