defmodule K6.Template.Grpc do
  @moduledoc """
  Generates a grpc template
  """
  use K6.Template

  @impl true
  def create(filename, opts) do
    url = Keyword.get(opts, :url, "localhost:9001")
    copy_template(template_path("grpc.js"), filename, url: url)
  end
end
