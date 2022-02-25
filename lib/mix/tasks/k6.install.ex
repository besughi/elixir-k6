defmodule Mix.Tasks.K6.Install do
  @moduledoc """
  Install k6 on the local project.

  The binary will be placed in `_build/k6`.

  ## Configuring k6 version

  You can set the specific k6 version to install in your `config.exs`:

      config :k6,
        version: "vX.Y.Z"

  By default version `v0.36.0` is installed.

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
