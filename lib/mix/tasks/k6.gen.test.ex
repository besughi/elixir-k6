defmodule Mix.Tasks.K6.Gen.Test do
  @moduledoc """
  Generates k6 test
  """
  use Mix.Task

  alias K6.Template

  @switches [
    type: :string
  ]

  @shortdoc "Generates a new k6 test"
  def run(args) do
    Mix.Task.run("app.start")

    case OptionParser.parse!(args, strict: @switches, aliases: []) do
      {switches, [test_name]} ->
        type = Keyword.get(switches, :type, "rest")
        filename = Path.join(["priv", "k6", test_name <> ".js"])

        do_generate(type, filename, [])

      {_switches, _positional_args} ->
        raise "Please provide a single name for your test."
    end
  end

  defp do_generate("rest", filename, opts), do: Template.Rest.generate(filename, opts)
  defp do_generate("graphql", filename, opts), do: Template.Graphql.generate(filename, opts)
  defp do_generate("grpc", filename, opts), do: Template.Grpc.generate(filename, opts)
end
