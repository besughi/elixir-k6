import Channel from "./utilities/phoenix-channel.js";
import { sleep } from "k6";

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
