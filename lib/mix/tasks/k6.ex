defmodule Mix.Tasks.K6 do
  use Mix.Task

  @binary_path Path.join(Path.dirname(Mix.Project.build_path()), "k6")

  @shortdoc "Installs K6 on the local machine"
  def run(args) when is_list(args) do
    test_dir = Path.join(["priv", "k6"])

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
