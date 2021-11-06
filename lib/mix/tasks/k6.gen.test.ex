defmodule Mix.Tasks.K6.Gen.Test do
  @moduledoc """
  Generate a new k6 test.

  Tests will be placed in the `priv/k6` folder of your project by default.
  This can be customized via the `:k6, :workdir` configuration.
  By default a test for a generic rest-like API will be generated.
  However, the template to use for the generation of tests can be specified
  via the `--type` flag.

  ## Command line options

    * `--type` - the template to use to generate the new test. Supported types are `rest` (default), `graphql`, `grpc`, `websocket`, `phoenix-channel` and `liveview`.
    * `--url` - the url of the target application. When not set, the generator will try to detect it automatically.

  ## Examples

      $ mix k6.gen.test test_name
      $ mix k6.gen.test --type graphql test_name
      $ mix k6.gen.test --url "http://localhost:8000" test_name
  """
  use Mix.Task

  alias K6.Template

  @switches [
    type: :string,
    url: :string
  ]

  @shortdoc "Generate a new k6 test"
  def run(args) do
    Mix.Task.run("app.start")

    case OptionParser.parse!(args, strict: @switches, aliases: []) do
      {switches, [test_name]} ->
        type = Keyword.get(switches, :type, "rest")
        filename = Path.join([tests_directory(), test_name <> ".js"])

        do_generate(type, filename, switches)

        Mix.shell().info("""

        Edit `#{filename}` to customize your load test.
        Once you're done run `mix k6 run #{test_name}.js` to execute it.

        For more info about running k6 see https://k6.io/docs/getting-started/running-k6/.
        """)

      {_switches, _positional_args} ->
        Mix.raise("Please provide a single name for your test.")
    end
  end

  defp do_generate("rest", filename, opts), do: Template.Rest.generate_and_save(filename, opts)

  defp do_generate("graphql", filename, opts),
    do: Template.Graphql.generate_and_save(filename, opts)

  defp do_generate("grpc", filename, opts), do: Template.Grpc.generate_and_save(filename, opts)

  defp do_generate("phoenix-channel", filename, opts),
    do: Template.PhoenixChannel.generate_and_save(filename, opts)

  defp do_generate("liveview", filename, opts),
    do: Template.Liveview.generate_and_save(filename, opts)

  defp do_generate("websocket", filename, opts),
    do: Template.WebSocket.generate_and_save(filename, opts)

  defp do_generate(type, _, _) do
    Mix.raise("""
    Type "#{type}" is not valid.
    Sypported types are `rest` (default), `graphql`, `grpc`, `websocket`, `phoenix-channel` and `liveview`
    """)
  end

  defp tests_directory, do: Application.get_env(:k6, :workdir, "priv/k6")
end
