defmodule K6.Template.Rest do
  import Mix.Generator

  def generate(filename, opts) do
    url = Keyword.get(opts, :url, "https://localhost:4000/")

    create_directory(Path.dirname(filename))
    create_file(filename, graphql_template(url: url))
  end

  embed_template(:graphql, """
  import http from 'k6/http';
  import {check, sleep} from 'k6';

  export default function() {
    const data = {};
    let res = http.post('<%= @url %>', data);
      check(res, { 'success login': (r) => r.status === 200 });
      sleep(0.3);
  }
  """)
end
