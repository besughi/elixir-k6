defmodule K6.Template.Rest do
  @moduledoc """
  Generates a rest template
  """
  import Mix.Generator

  alias K6.Template

  @spec generate(binary, keyword) :: :ok
  def generate(filename, opts) do
    url = Keyword.get(opts, :url, Template.default_base_url())

    create_directory(Path.dirname(filename))
    create_file(filename, rest_template(url: url))
    :ok
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
