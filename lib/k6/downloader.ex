defmodule K6.Downloader do
  @doc """
  Downloads k6 package according to target os
  """
  def download! do
    case :httpc.request(:get, {binary_url(), []}, [], body_format: :binary) do
      {:ok, {{_, 200, _}, _headers, body}} ->
        body

      other ->
        raise "couldn't fetch #{binary_url()}: #{inspect(other)}"
    end
  end

  defp binary_url, do: "https://github.com/grafana/k6/releases/download/#{version()}/#{target()}"

  defp target do
    case :os.type() do
      {:unix, :darwin} ->
        "k6-#{version()}-macos-amd64.zip"

      other ->
        raise "Not implemented for #{inspect(other)}"
    end
  end

  defp version, do: "v0.34.1"
end
