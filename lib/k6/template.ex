defmodule K6.Template do
  @moduledoc """
  Utility functions for a k6 template
  """
  @default_http_base_url "http://localhost:80"

  @callback generate(keyword) :: :ok

  defmacro __using__(_) do
    quote do
      import Mix.Generator
      import K6.Template
      @behaviour K6.Template

      @spec generate_and_save(binary, keyword) :: :ok
      def generate_and_save(filename, opts) do
        create_directory(Path.dirname(filename))
        create_file(filename, generate(opts))
        :ok
      end
    end
  end

  def default_http_base_url do
    mix_app = Mix.Project.config()[:app]
    config = Application.get_all_env(mix_app)

    phoenix_endpoint =
      config
      |> Enum.map(fn {key, _value} -> key end)
      |> Enum.find(&phoenix_endpoint?/1)

    if phoenix_endpoint != nil do
      phoenix_endpoint.url()
    else
      @default_http_base_url
    end
  end

  defp phoenix_endpoint?(term) do
    "Endpoint" == term |> Module.split() |> Enum.at(-1)
  rescue
    _ -> false
  end
end
