defmodule K6.Downloader do

  alias K6.Target

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

  defp binary_url do
    "https://github.com/grafana/k6/releases/download/#{version()}/#{Target.get!}"
  end

  defp version, do: Application.get_env(:k6, :version, "v0.34.1")
end
