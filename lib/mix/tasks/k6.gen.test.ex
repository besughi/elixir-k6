defmodule Mix.Tasks.K6.Gen.Test do
  use Mix.Task

  @shortdoc "Generates a new k6 test"
  def run(args) do
    test_name =
      case OptionParser.parse!(args, strict: [], aliases: []) do
        {_switches, [test_name]} -> test_name
        {_switches, _positional_args} -> raise "Please provide a single name for your test."
      end

    filename = Path.join(["priv", "k6", test_name <> ".js"])

    K6.Template.Graphql.generate(filename, url: "http://localhost:4000/graphql")
  end
end
