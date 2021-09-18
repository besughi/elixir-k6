defmodule K6.Downloader do

  alias K6.Target

  @doc """
  Downloads k6 package according to target os
  """
  def download!(k6_version) do
    case :httpc.request(:get, {binary_url(k6_version), []}, [], body_format: :binary) do
      {:ok, {{_, 200, _}, _headers, body}} ->
        body

      other ->
        raise "couldn't fetch #{binary_url(k6_version)}: #{inspect(other)}"
    end
  end

  defp binary_url(k6_version) do
    "https://github.com/grafana/k6/releases/download/#{k6_version}/#{Target.get!(k6_version)}"
  end

end
