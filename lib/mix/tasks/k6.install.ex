defmodule Mix.Tasks.K6.Install do
  use Mix.Task

  alias K6.Archive
  alias K6.Downloader

  @binary_path Path.join(Path.dirname(Mix.Project.build_path()), "k6")

  @shortdoc "Installs k6 on the local machine"
  def run(_) do
    {:ok, _} = Application.ensure_all_started(:inets)
    {:ok, _} = Application.ensure_all_started(:ssl)

    body = Downloader.download!

    {:ok, content} = Archive.extract(body, :zip, "k6")

    File.write!(@binary_path, content)
    File.chmod!(@binary_path, 0o755)
  end
end
