defmodule Mix.Tasks.K6.Gen.Test do
  @moduledoc """
  Generate a new k6 test.

  The tests will be placed in the `priv/k6` folder of your project.
  By default a test for a generic rest-like API will be generated.
  However, the template to use for the generation of tests can be specified
  via the `--type` flag.

  ## Examples

      $ mix k6.gen.test test_name
      $ mix k6.gen.test --type graphql test_name
      $ mix k6.gen.test --url "http://localhost:8000" test_name

  ## Command line options

    * `--type` - the template to use to generate the new test. Supported types are `rest` (default), `graphql` and `grpc`.
    * `--url` - the url of the target application. When not set, the generator will try to detect it automatically.
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
        filename = Path.join(["priv", "k6", test_name <> ".js"])

        do_generate(type, filename, switches)

      {_switches, _positional_args} ->
        raise "Please provide a single name for your test."
    end
  end

  defp do_generate("rest", filename, opts), do: Template.Rest.generate_and_save(filename, opts)

  defp do_generate("graphql", filename, opts),
    do: Template.Graphql.generate_and_save(filename, opts)

  defp do_generate("grpc", filename, opts), do: Template.Grpc.generate_and_save(filename, opts)
end
