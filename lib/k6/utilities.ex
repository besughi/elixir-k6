defmodule K6.Utilities do
  @moduledoc """
  Utility functions for a k6 template
  """

  import Mix.Generator
  alias K6.Template

  @utilities ["phoenix-channel.js", "phoenix-liveview.js"]

  @spec generate(binary()) :: :ok
  def generate(path) do
    unless File.exists?(path) do
      create_directory(path)
      for utility <- @utilities, do: create_utility(path, utility)
    end

    :ok
  end

  defp create_utility(path, utility) do
    target_path = Path.join([path, utility])
    original_path = Template.template_path("utilities/" <> utility)

    copy_file(original_path, target_path)
  end
end
