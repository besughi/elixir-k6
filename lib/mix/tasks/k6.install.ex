defmodule Mix.Tasks.K6.Install do
  @moduledoc """
  Install k6 on the local project.

  The binary will be placed in `_build/k6`.

  ## Examples

      $ mix k6.install
  """
  use Mix.Task

  alias K6.Installer

  @shortdoc "Install k6 on the local project"
  def run(_) do
    {:ok, _} = Application.ensure_all_started(:inets)
    {:ok, _} = Application.ensure_all_started(:ssl)

    Installer.install!()
  end
end
