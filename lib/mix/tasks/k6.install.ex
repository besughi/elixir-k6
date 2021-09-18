defmodule Mix.Tasks.K6.Install do
  use Mix.Task

  alias K6.Installer

  @shortdoc "Installs k6 on the local machine"
  def run(_) do
    {:ok, _} = Application.ensure_all_started(:inets)
    {:ok, _} = Application.ensure_all_started(:ssl)

    Installer.install!()
  end
end
