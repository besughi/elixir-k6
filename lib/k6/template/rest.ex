defmodule K6.Template.Rest do
  import Mix.Generator

  alias K6.Template

  def generate(filename, opts) do
    url = Keyword.get(opts, :url, Template.default_base_url())

    create_directory(Path.dirname(filename))
    create_file(filename, rest_template(url: url))
  end

  embed_template(:rest, """
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
