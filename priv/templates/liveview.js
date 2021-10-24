import Liveview from "./utilities/phoenix-liveview.js";

// See https://k6.io/docs/using-k6/options/#using-options for documentation on k6 options
export const options = {
  vus: 10,
  duration: '30s',
};

export default function () {
  let liveview = new Liveview("<%= @http_url %>", "<%= @websocket_url %>");

  liveview.connect(() => {
    liveview.send(
      "event",
      { type: "click", event: "nav", value: { page: "2" } },
      (_response) => {
        liveview.leave();
      }
    );
  });
}
