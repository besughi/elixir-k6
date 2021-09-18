defmodule Mix.Tasks.K6.Gen.Test do
  use Mix.Task
  import Mix.Generator

  @shortdoc "Generates a new k6 test"
  def run(args) do
    test_name =
      case OptionParser.parse!(args, strict: [], aliases: []) do
        {_switches, [test_name]} -> test_name
        {_switches, _positional_args} -> raise "Please provide a single name for your test."
      end

    file = Path.join(["priv", "k6", test_name <> ".js"])

    create_directory(Path.dirname(file))
    create_file(file, graphql_template(url: "http://localhost:4000/graphql"))
  end

  embed_template(:graphql, """
  import http from "k6/http";
  import { sleep } from "k6";

  export default function() {
    let query = `
      query Query {
        field(arg: "arg") {
          data
        }
      }`;

    let headers = {'Content-Type': 'application/json'};

    let res = http.post("<%= @url %>",
      JSON.stringify({ query: query }),
      {headers: headers}
    );

    sleep(0.3);
  };
  """)
end
