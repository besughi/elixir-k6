defmodule K6.Template.Grpc do
  @moduledoc """
  Generates a grpc template
  """
  import Mix.Generator

  @spec generate(binary, keyword) :: :ok
  def generate(filename, opts) do
    url = Keyword.get(opts, :url, "localhost:9001")

    create_directory(Path.dirname(filename))
    create_file(filename, grpc_template(url: url))
    :ok
  end

  embed_template(:grpc, """
  import grpc from 'k6/net/grpc';
  import { check } from 'k6';

  const client = new grpc.Client();
  client.load(['definitions'], 'hello.proto');

  export default () => {
    client.connect('<%= @url %>', { plaintext: false });

    const data = { greeting: 'Bert' };
    const response = client.invoke('hello.HelloService/SayHello', data);
    check(response, {
      'status is OK': (r) => r && r.status === grpc.StatusOK,
    });
    console.log(JSON.stringify(response.message));

    client.close();
    sleep(1);
  };

  """)
end
