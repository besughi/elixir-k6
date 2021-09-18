defmodule K6.Target do
  @doc """
  Returns target system
  """
  @spec get! :: String.t()
  def get! do
    case :os.type() do
      {:unix, :darwin} ->
        "k6-#{version()}-macos-amd64.zip"

      other ->
        raise "Not implemented for #{inspect(other)}"
    end
  end

  defp version, do: Application.get_env(:k6, :version, "v0.34.1")

end
