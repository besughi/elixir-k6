import grpc from "k6/net/grpc";
import { check } from "k6";

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
