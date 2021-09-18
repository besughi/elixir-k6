defmodule Mix.Tasks.K6.Install do
  @moduledoc """
  Installs k6 on environment
  """
  use Mix.Task

  alias K6.Installer

  @shortdoc "Installs k6 on the local machine"
  def run(_) do
    {:ok, _} = Application.ensure_all_started(:inets)
    {:ok, _} = Application.ensure_all_started(:ssl)

    Installer.install!()
  end
end
