defmodule Mix.Tasks.K6 do
  @moduledoc """
  Runs k6 commands

  The command runs using the binary installed locally in the `_build` folder of the project.
  If k6 is not installed for the local project, it will automatically install it before running the command.

  k6 is be executed inside the `priv/k6` folder of your project, where k6 tests reside.

  ## Examples

      $ mix k6 run my_test.js
  """
  use Mix.Task
  require Logger

  @binary_path Path.join(Path.dirname(Mix.Project.build_path()), "k6")

  @shortdoc "Runs k6"
  def run(args) when is_list(args) do
    unless File.exists?(@binary_path), do: Mix.Task.run("k6.install")

    test_dir = Path.join(["priv", "k6"])
    unless File.exists?(test_dir), do: File.mkdir_p(test_dir)

    options = [
      :nouse_stdio,
      :exit_status,
      args: args,
      cd: String.to_charlist(test_dir),
      env: k6_env()
    ]

    Logger.debug("Running k6 with args #{args} and env #{inspect(options[:env])}")

    port = Port.open({:spawn_executable, @binary_path}, options)

    receive do
      {^port, {:exit_status, exit_status}} ->
        Logger.debug("K6 exited with status #{exit_status}")
        exit_status
    end
  end

  defp k6_env do
    stringify = fn s -> String.to_charlist(to_string(s)) end
    stringify_kv = fn {k, v} -> {stringify.(k), stringify.(v)} end

    :k6
    |> Application.get_env(:env, [])
    |> Enum.into([], stringify_kv)
  end
end
