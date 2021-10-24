import grpc from "k6/net/grpc";
import { check } from "k6";

// See https://k6.io/docs/using-k6/options/#using-options for documentation on k6 options
export const options = {
  vus: 10,
  duration: '30s',
};

const client = new grpc.Client();
client.load(["definitions"], "hello.proto");

export default () => {
  // To set dynamic (e.g. environment-specific) configuration, pass it either as environment
  // variable when invoking k6 or by setting `:k6, env: [key: "value"]` in your `config.exs`,
  // and then access it from `__ENV`, e.g.: `const url = __ENV.url`

  client.connect("<%= @url %>", { plaintext: false });

  // See https://k6.io/docs/using-k6/protocols/grpc/ for documentation on k6 and gRPC
  const data = { greeting: "Bert" };
  const response = client.invoke("hello.HelloService/SayHello", data);
  check(response, {
    "status is OK": (r) => r && r.status === grpc.StatusOK,
  });
  console.log(JSON.stringify(response.message));

  client.close();
  sleep(1);
};
