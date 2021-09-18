defmodule Mix.Tasks.K6.Install do
  use Mix.Task

  @binary_url "https://github.com/grafana/k6/releases/download/v0.34.1/k6-v0.34.1-macos-amd64.zip"

  @shortdoc "Installs K6 on the local machine"
  def run(_) do
    {:ok, _} = Application.ensure_all_started(:inets)
    {:ok, _} = Application.ensure_all_started(:ssl)

    body =
      case :httpc.request(:get, {@binary_url, []}, [], body_format: :binary) do
        {:ok, {{_, 200, _}, _headers, body}} ->
          body

        other ->
          raise "couldn't fetch #{@binary_url}: #{inspect(other)}"
      end

    {:ok, archive} = :zip.zip_open(body, [:memory])
    {:ok, {_file_name, content}} = :zip.zip_get(~c'k6-v0.34.1-macos-amd64/k6', archive)
    :zip.zip_close(archive)

    File.write!("/tmp/xyz", content)
    File.chmod!("/tmp/xyz", 0o755)
  end
end
