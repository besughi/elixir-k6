defmodule K6.TestSupport.E2eUtils do
  @moduledoc false

  def generate_test_app(path), do: System.cmd("mix", ["new", path])

  def add_k6_dep(app_path) do
    mix_file = Path.join(app_path, "mix.exs")
    k6_dep = ~s<{:k6, path: "#{File.cwd!()}"}>

    mix_file
    |> File.read!()
    |> String.replace("deps: deps()", "deps: [#{k6_dep} | deps()]")
    |> then(&File.write!(mix_file, &1))

    command("mix", ["deps.get"], app_path)
  end

  def generate_load_test(app_path, args) do
    command(
      "mix",
      ["k6.gen.test" | args],
      app_path
    )
  end

  def run_load_test(app_path, test_name) do
    command("mix", ["k6", "run", test_name <> ".js"], app_path)
  end

  defp command(cmd, args, app_path) do
    case System.cmd(cmd, args, cd: app_path) do
      {stdout, 0} -> {stdout, 0}
      {_, exit_code} -> raise "Command #{cmd} #{inspect(args)} failed with exit code #{exit_code}"
    end
  end
end
