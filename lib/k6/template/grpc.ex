defmodule K6.Template.Grpc do
  @moduledoc """
  Generates a grpc template
  """
  use K6.Template

  @impl true
  def create(filename, opts) do
    url = Keyword.get(opts, :url, "localhost:9001")
    copy_template(template_path("grpc.js"), filename, url: url)
    copy_template(template_path("definitions/hello.proto"), proto_path(filename), [])
  end

  defp proto_path(filename) do
    filename
    |> Path.dirname()
    |> Path.join("definitions/hello.proto")
  end
end
