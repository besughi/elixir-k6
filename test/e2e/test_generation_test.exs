defmodule K6.E2e.TestGenerationTest do
  use ExUnit.Case

  alias K6.TestSupport.E2eUtils

  @moduletag :end_to_end

  setup_all do
    tmp_dir = System.tmp_dir!()

    app_path = Path.join(tmp_dir, "test_generation_test_app")

    File.rm_rf!(app_path)

    E2eUtils.generate_test_app!(app_path)
    E2eUtils.add_k6_dep!(app_path)

    {:ok, app_path: app_path}
  end

  setup %{app_path: app_path} do
    File.rm_rf!(tests_dir(app_path))
    :ok
  end

  test "prints error message when the supplied type is not valid", %{app_path: app_path} do
    {stdout, exit_code} =
      E2eUtils.generate_load_test(app_path, ["sample_test", "--type", "invalid_test_type"])

    assert exit_code != 0
    assert stdout =~ "is not valid."
  end

  test "generates utilities for channels and liveview", %{app_path: app_path} do
    test_name = "sample_test"

    E2eUtils.generate_load_test!(app_path, [test_name, "--type", "liveview"])

    dir = tests_dir(app_path)
    channel_utilities = File.read!(Path.join(dir, "utilities/phoenix-channel.js"))
    liveview_utilities = File.read!(Path.join(dir, "utilities/phoenix-liveview.js"))
    test_stub = File.read!(Path.join(dir, test_name <> ".js"))

    assert channel_utilities =~ "export default class Channel"
    assert liveview_utilities =~ "export default class Liveview"
    assert test_stub =~ "let liveview = new Liveview("
  end

  test "warns that some test types are still experimental", %{app_path: app_path} do
    {liveview_stdout, _} =
      E2eUtils.generate_load_test(app_path, ["liveview_test", "--type", "liveview"])

    {phoenix_channel_stdout, _} =
      E2eUtils.generate_load_test(app_path, ["phoenix_channel_test", "--type", "phoenix-channel"])

    {rest_stdout, _} = E2eUtils.generate_load_test(app_path, ["rest_test", "--type", "rest"])

    assert liveview_stdout =~ "experimental"
    assert phoenix_channel_stdout =~ "experimental"
    refute rest_stdout =~ "experimental"
  end

  defp tests_dir(app_path), do: Path.join(app_path, "priv/k6")
end
