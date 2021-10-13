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

    System.cmd("mix", ["deps.get"], cd: app_path)
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
    System.cmd("mix", ["k6", "run", test_name <> ".js"], cd: app_path)
  end
end
