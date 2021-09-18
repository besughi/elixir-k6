defmodule K6.Target do
  @doc """
  Returns k6 target version according to system
  """
  @spec get!(String.t()) :: String.t()
  def get!(version) do
    case :os.type() do
      {:unix, :darwin} ->
        "k6-#{version}-macos-amd64.zip"

      other ->
        raise "Not implemented for #{inspect(other)}"
    end
  end
end
