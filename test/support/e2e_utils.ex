defmodule K6.TestSupport.E2eUtils do
  @moduledoc false

  def generate_test_app!(path) do
    "mix"
    |> System.cmd(["new", path])
    |> assert_successful()
  end

  def add_k6_dep!(app_path) do
    mix_file = Path.join(app_path, "mix.exs")
    k6_dep = ~s<{:k6, path: "#{File.cwd!()}"}>

    mix_file
    |> File.read!()
    |> String.replace("deps: deps()", "deps: [#{k6_dep} | deps()]")
    |> then(&File.write!(mix_file, &1))

    "mix"
    |> System.cmd(["deps.get"], cd: app_path)
    |> assert_successful()
  end

  def generate_load_test!(app_path, args) do
    app_path
    |> generate_load_test(args)
    |> assert_successful()
  end

  def generate_load_test(app_path, args) do
    System.cmd(
      "mix",
      ["k6.gen.test" | args],
      cd: app_path,
      stderr_to_stdout: true
    )
  end

  def run_load_test(app_path, test_name) do
    "mix"
    |> System.cmd(["k6", "run", test_name <> ".js"], cd: app_path)
  end

  defp assert_successful(cmd_result) do
    case cmd_result do
      {stdout, 0} -> {stdout, 0}
      {_, exit_code} -> raise "Command failed with exit code #{exit_code}"
    end
  end
end
