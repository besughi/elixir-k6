defmodule K6.Utilities do
  @moduledoc """
  Utility functions for a k6 template
  """

  import Mix.Generator
  alias K6.Template

  @spec create(String.t(), [String.t()]) :: :ok
  def create(_, []), do: :ok

  def create(tests_directory, utilities) do
    for utility <- utilities, do: create_utility(tests_directory, utility)

    :ok
  end

  defp create_utility(path, utility) do
    target_path = Path.join([path, "utilities", utility])

    unless File.exists?(target_path) do
      original_path = Template.template_path("utilities/" <> utility)
      copy_file(original_path, target_path)
    end
  end
end
