defmodule K6.Template.Graphql do
  import Mix.Generator

  def generate(filename, opts) do
    url = Keyword.get(opts, :url, "https://localhost:4000/graphql")

    create_directory(Path.dirname(filename))
    create_file(filename, graphql_template(url: url))
  end

  embed_template(:graphql, """
  import http from 'k6/http';
  import { sleep } from 'k6';

  export default function() {
    let query = `
      query Query {
        field(arg: "arg") {
          data
        }
      }`;

    let headers = {'Content-Type': 'application/json'};

    let res = http.post('<%= @url %>',
      JSON.stringify({ query: query }),
      {headers: headers}
    );

    sleep(0.3);
  };
  """)
end
