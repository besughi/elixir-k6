defmodule K6.E2e.TestGenerationTest do
  use ExUnit.Case, async: true

  alias K6.TestSupport.E2eUtils

  setup_all do
    tmp_dir = System.tmp_dir!()

    app_path = Path.join(tmp_dir, "test_generation_test_app")

    File.rm_rf!(app_path)

    E2eUtils.generate_test_app(app_path)
    E2eUtils.add_k6_dep(app_path)

    {:ok, app_path: app_path}
  end

  setup %{app_path: app_path} do
    File.rm_rf!(tests_dir(app_path))
  end

  test "generates phoenix channel template and utilities", %{app_path: app_path} do
    test_name = "sample_test"

    E2eUtils.generate_load_test(app_path, [test_name, "--type", "phoenix-channel"])

    dir = tests_dir(app_path)
    utilities = File.read!(Path.join(dir, "utilities/phoenix-channel.js"))
    test_stub = File.read!(Path.join(dir, test_name <> ".js"))

    assert utilities =~ "export default class Channel"
    assert test_stub =~ "let channel = new Channel("
  end

  defp tests_dir(app_path), do: Path.join(app_path, "priv/k6")
end
