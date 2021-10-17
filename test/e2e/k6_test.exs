defmodule K6.E2e.K6Test do
  use ExUnit.Case

  alias K6.TestSupport.E2eUtils

  @moduletag :end_to_end

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

    E2eUtils.generate_test_app!(app_path)
    E2eUtils.add_k6_dep!(app_path)

    E2eUtils.generate_load_test!(app_path, [test_name, "--url", "http://localhost:#{bypass.port}"])

    {stdout, exit_code} = E2eUtils.run_load_test(app_path, test_name)

    assert 0 == exit_code
    assert stdout =~ "script: #{test_name}.js"
  end
end
