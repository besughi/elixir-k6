defmodule K6.Template do
  @moduledoc """
  Utility functions for a k6 template
  """
  @default_host_and_port {"localhost", 4000}

  @callback needs_utilities() :: [String.t()]
  @callback create(filename :: String.t(), opts :: keyword) :: boolean()

  defmacro __using__(_) do
    quote do
      import Mix.Generator
      import K6.Template

      @behaviour K6.Template

      @impl true
      def needs_utilities, do: []

      defoverridable needs_utilities: 0

      @spec generate_and_save(binary, keyword) :: :ok
      def generate_and_save(filename, opts) do
        directory_path = Path.dirname(filename)

        unless File.exists?(directory_path), do: create_directory(directory_path)
        K6.Utilities.create(directory_path, needs_utilities())
        create(filename, opts)
        :ok
      end
    end
  end

  def template_path(template) do
    Path.join([Application.app_dir(:k6), "priv/templates/", template])
  end

  def default_host_and_port, do: @default_host_and_port
end
