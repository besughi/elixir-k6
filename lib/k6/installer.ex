defmodule K6.Installer do
  @moduledoc """
  Module used to install k6.

  k6 version can be explicitly configured with:
  ```
  config :k6, version: "vX.X.X"
  ```
  If no k6 version is set the default is v0.36.0.
  """
  alias K6.Archive
  alias K6.Downloader

  @binary_path Path.join(Path.dirname(Mix.Project.build_path()), "k6")

  @doc """
  Installs k6
  """
  def install! do
    {file_type, body} = Downloader.download!(k6_version())

    content = Archive.extract!(body, file_type, "k6")

    File.write!(@binary_path, content)
    File.chmod!(@binary_path, 0o755)
  end

  defp k6_version, do: Application.get_env(:k6, :version, "v0.36.0")
end
