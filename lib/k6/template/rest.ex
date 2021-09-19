defmodule K6.Template.Rest do
  @moduledoc """
  Generates a rest template
  """
  use K6.Template

  @impl true
  def generate(opts) do
    url = Keyword.get(opts, :url, default_rest_base_url())
    rest_template(url: url)
  end

  defp default_rest_base_url do
    {host, port} = default_host_and_port()
    "http://#{host}:#{port}"
  end

  embed_template(:rest, """
  import http from 'k6/http';
  import {check, sleep} from 'k6';

  export default function() {
    const data = {};
    let res = http.post('<%= @url %>', data);
      check(res, { 'success': (r) => r.status === 200 });
      sleep(0.3);
  }
  """)
end
