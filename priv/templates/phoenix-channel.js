import Channel from "./utilities/phoenix-channel.js";
import { sleep } from "k6";

// See https://k6.io/docs/using-k6/options/#using-options for documentation on k6 options
export const options = {
  vus: 10,
  duration: '30s',
};

export default function () {
  let broadcastCallback = () => {};
  let channel = new Channel("<%= @url %>", "my_room:lobby", broadcastCallback);

  channel.join({}, () => {
    console.log("joined");

    channel.send("ping", { data: "content" }, (response) => {
      console.log(JSON.stringify(response));
      channel.send("ping", { data: "content" });
      channel.leave();
    });
  });
  sleep(1);
}
