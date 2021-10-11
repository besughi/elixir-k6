defmodule K6.E2e.K6Test do
  use ExUnit.Case, async: true

  setup do
    bypass = Bypass.open()
    {:ok, bypass: bypass}
  end

  @tag :tmp_dir
  # do not put commas in the test name, or it'll break the test :D
  test "installs generates and executes load test for simple API", %{
    bypass: bypass,
    tmp_dir: tmp_dir
  } do
    app_path = Path.join(tmp_dir, "test_app")
    test_name = "sample_test"
    Bypass.expect(bypass, &Plug.Conn.resp(&1, 200, "sample response"))

    generate_test_app(app_path)
    add_k6_dep(app_path)
    generate_load_test(app_path, test_name, bypass.port)
    exit_code = run_load_test(app_path, test_name)

    assert 0 == exit_code
  end

  defp generate_test_app(path), do: System.cmd("mix", ["new", path], stderr_to_stdout: true)

  defp add_k6_dep(app_path) do
    mix_file = Path.join(app_path, "mix.exs")
    k6_dep = ~s<{:k6, path: "#{File.cwd!()}"}>

    mix_file
    |> File.read!()
    |> String.replace("deps: deps()", "deps: [#{k6_dep} | deps()]")
    |> then(&File.write!(mix_file, &1))

    System.cmd("mix", ["deps.get"], cd: app_path)
  end

  defp generate_load_test(app_path, test_name, port) do
    System.cmd(
      "mix",
      ["k6.gen.test", test_name, "--url", "http://localhost:#{port}"],
      cd: app_path,
      stderr_to_stdout: true
    )
  end

  defp run_load_test(app_path, test_name) do
    {_stdout, exit_code} = System.cmd("mix", ["k6", "run", test_name <> ".js"], cd: app_path)
    exit_code
  end
end
