defmodule Mix.Tasks.K6 do
  @moduledoc """
  Runs k6 commands

  The command runs using the binary installed locally in the `_build` folder of the project.
  If k6 is not installed for the local project, it will automatically install it before running the command.

  k6 is executed in the folder where k6 tests reside, which defaults to `priv/k6`.

  ## Examples

      $ mix k6 run my_test.js
      $ mix k6 run --vus 10 --duration 30s my_test.js
  """
  use Mix.Task

  @shortdoc "Runs k6"
  def run(args) when is_list(args) do
    unless correct_version_installed?(), do: Mix.Task.run("k6.install")

    test_dir = tests_directory()
    unless File.exists?(test_dir), do: File.mkdir_p(test_dir)

    wrapper_args = [binary_path() | args]

    options = [
      :nouse_stdio,
      :exit_status,
      args: wrapper_args,
      cd: String.to_charlist(test_dir),
      env: k6_env()
    ]

    port = Port.open({:spawn_executable, wrapper_path()}, options)

    receive do
      {^port, {:exit_status, exit_status}} -> exit({:shutdown, exit_status})
    end
  end

  defp k6_env do
    stringify = fn s -> String.to_charlist(to_string(s)) end

    :k6
    |> Application.get_env(:env, [])
    |> Enum.into([], fn {k, v} -> {stringify.(k), stringify.(v)} end)
  end

  defp binary_path, do: Path.join(Path.dirname(Mix.Project.build_path()), "k6")
  defp wrapper_path, do: Path.join(Application.app_dir(:k6), "priv/wrapper.sh")
  defp tests_directory, do: Application.get_env(:k6, :workdir, "priv/k6")

  defp correct_version_installed? do
    path = binary_path()

    if File.exists?(path) do
      expected_version = Application.get_env(:k6, :version, "v0.39.0")
      installed_version() == expected_version
    else
      false
    end
  end

  defp installed_version do
    {res, 0 = _exit_code} = System.cmd(binary_path(), ["version"])
    ["k6", version | _] = String.split(res, " ", trim: true)
    version
  end
end
