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
  client.connect("<%= @url %>", { plaintext: false });

  const data = { greeting: "Bert" };
  const response = client.invoke("hello.HelloService/SayHello", data);
  check(response, {
    "status is OK": (r) => r && r.status === grpc.StatusOK,
  });
  console.log(JSON.stringify(response.message));

  client.close();
  sleep(1);
};
