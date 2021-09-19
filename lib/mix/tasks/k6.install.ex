defmodule Mix.Tasks.K6.Install do
  @moduledoc """
  Install k6 on the local project.

  The binary will be placed in `_build/k6`.

  ## Configuring k6 version
  By default k6 v0.34.1 will be installed.
  You can install a specific k6 version with:

      config :k6,
        version: "vX.Y.Z"

  ## Examples

      $ mix k6.install

  """
  use Mix.Task

  alias K6.Installer

  @shortdoc "Install k6 on the local project"
  def run(_) do
    {:ok, _} = Application.ensure_all_started(:inets)
    {:ok, _} = Application.ensure_all_started(:ssl)

    shell = Mix.shell()
    shell.info("Installing k6 locally...")

    Installer.install!()

    shell.info("Done.")
  rescue
    e -> Mix.raise(e.message)
  end
end
