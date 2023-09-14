import Channel from "./utilities/phoenix-channel.js";
import { check } from "k6";

// See https://k6.io/docs/using-k6/options/#using-options for documentation on k6 options
export const options = {
  vus: 10,
  duration: '30s',
};

export default function () {
  // To set dynamic (e.g. environment-specific) configuration, pass it either as environment
  // variable when invoking k6 or by setting `:k6, env: [key: "value"]` in your `config.exs`,
  // and then access it from `__ENV`, e.g.: `const url = __ENV.url`

  let params = {};
  let broadcastCallback = () => {};
  let channel = new Channel("<%= @url %>", "my_room:lobby", params, broadcastCallback);

  let res = channel.join({}, () => {
    console.log("joined");

    channel.send("ping", { data: "content" }, (response) => {
      console.log(JSON.stringify(response));
      channel.send("ping", { data: "content" });
      channel.leave();
    });
  });

  check(res, { "status is 101": (r) => r && r.status === 101 });
}
