defmodule K6.Installer do

  alias K6.Archive
  alias K6.Downloader

  @binary_path Path.join(Path.dirname(Mix.Project.build_path()), "k6")

  @doc """
  Installs k6
  """
  def install! do
    body = Downloader.download!(k6_version())

    {:ok, content} = Archive.extract(body, :zip, "k6")

    File.write!(@binary_path, content)
    File.chmod!(@binary_path, 0o755)
  end

  defp k6_version, do: Application.get_env(:k6, :version, "v0.34.1")

end
