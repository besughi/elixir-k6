defmodule Mix.Tasks.K6 do
  @moduledoc """
  Runs k6
  """
  use Mix.Task

  @binary_path Path.join(Path.dirname(Mix.Project.build_path()), "k6")

  @shortdoc "Runs K6 on the local machine"
  def run(args) when is_list(args) do
    unless File.exists?(@binary_path) do
      Mix.Task.run("k6.install")
    end

    test_dir = Path.join(["priv", "k6"])

    unless File.exists?(test_dir) do
      File.mkdir_p(test_dir)
    end

    opts = [
      cd: test_dir,
      into: IO.stream(:stdio, :line),
      stderr_to_stdout: true
    ]

    @binary_path
    |> System.cmd(args, opts)
    |> elem(1)
  end
end
