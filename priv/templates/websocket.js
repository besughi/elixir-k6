import ws from "k6/ws";
import { check } from "k6";

// See https://k6.io/docs/using-k6/options/#using-options for documentation on k6 options
export const options = {
  vus: 10,
  duration: '30s',
};

export default function () {
  const url = "<%= @url %>";
  const params = { tags: { my_tag: "hello" } };

  const res = ws.connect(url, params, function (socket) {
    socket.on("open", () => console.log("connected"));
    socket.on("message", (data) => console.log("Message received: ", data));
    socket.on("close", () => console.log("disconnected"));
  });

  check(res, { "status is 101": (r) => r && r.status === 101 });
}
