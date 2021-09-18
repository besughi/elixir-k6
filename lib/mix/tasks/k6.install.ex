defmodule Mix.Tasks.K6.Install do
  use Mix.Task

  @binary_path Path.join(Path.dirname(Mix.Project.build_path()), "k6")

  @shortdoc "Installs K6 on the local machine"
  def run(_) do
    {:ok, _} = Application.ensure_all_started(:inets)
    {:ok, _} = Application.ensure_all_started(:ssl)

    body =
      case :httpc.request(:get, {binary_url(), []}, [], body_format: :binary) do
        {:ok, {{_, 200, _}, _headers, body}} ->
          body

        other ->
          raise "couldn't fetch #{binary_url()}: #{inspect(other)}"
      end

    {:ok, archive} = :zip.zip_open(body, [:memory])
    {:ok, {_file_name, content}} = :zip.zip_get(~c'k6-v0.34.1-macos-amd64/k6', archive)
    :zip.zip_close(archive)

    File.write!(@binary_path, content)
    File.chmod!(@binary_path, 0o755)
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
