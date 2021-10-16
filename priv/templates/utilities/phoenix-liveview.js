import Channel from "./phoenix-channel.js";
import http from "k6/http";
import { parseHTML } from "k6/html";
import { URL } from "https://jslib.k6.io/url/1.0.0/index.js";

export default class Liveview {
  constructor(url, websocket_url) {
    this.url = new URL(url);
    this.websocket_url = new URL(websocket_url);
    this.channel = null;
  }

  connect(callback, parse_body = this._parse_body) {
    let response = http.get(this.url.toString());
    let { csrf_token, phx_id, phx_session, phx_static } = parse_body(
      response.body
    );

    this.websocket_url.searchParams.append("vsn", "2.0.0");
    this.websocket_url.searchParams.append("_csrf_token", csrf_token);

    this.channel = new Channel(
      this.websocket_url.toString(),
      `lv:${phx_id}`,
      this._params(response.cookies),
      () => {}
    );

    this.channel.join(
      {
        url: this.url.toString(),
        session: phx_session,
        static: phx_static,
      },
      callback
    );
  }

  leave() {
    this.channel.leave();
  }

  send(event, payload, callback = () => {}) {
    this.channel.send(event, payload, callback);
  }

  _params(cookies) {
    return { headers: { Cookie: this._cookie_header_for(cookies) } };
  }

  _cookie_header_for(all_cookies) {
    // unfortunately the websocket client from k6 does not natively support cookies,
    // so we have to work around that issue by building the Cookie header ourselves
    let cookie_header = "";
    for (const [_name, cookies] of Object.entries(all_cookies)) {
      for (const cookie of cookies) {
        cookie_header += ` ${cookie.name}=${cookie.value};`;
      }
    }
    return cookie_header;
  }

  _parse_body(body) {
    let doc = parseHTML(body);
    let csrf_token = doc.find('input[name="_csrf_token"]').attr("value");

    let phx_main = doc.find('div[data-phx-main="true"]');
    let phx_id = phx_main.attr("id");
    let phx_session = phx_main.attr("data-phx-session");
    let phx_static = phx_main.attr("data-phx-static");

    return {
      csrf_token,
      phx_main,
      phx_id,
      phx_session,
      phx_static,
    };
  }
}
