import Channel from "./phoenix-channel.js";
import http from "k6/http";
import { parseHTML } from "k6/html";
import { URL } from "https://jslib.k6.io/url/1.0.0/index.js";

export default class Liveview {
  constructor(url, websocketUrl) {
    this.url = new URL(url);
    this.websocketUrl = new URL(websocketUrl);
    this.channel = null;
  }

  connect(callback, parseBody = this._parseBody) {
    let response = http.get(this.url.toString());
    let { csrfToken, phxId, phxSession, phxStatic } = parseBody(
      response.body
    );

    this.websocketUrl.searchParams.append("vsn", "2.0.0");
    this.websocketUrl.searchParams.append("_csrf_token", csrfToken);

    this.channel = new Channel(
      this.websocketUrl.toString(),
      `lv:${phxId}`,
      this._params(response.cookies),
      () => {}
    );

    this.channel.join(
      {
        url: this.url.toString(),
        session: phxSession,
        static: phxStatic,
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
    return { headers: { Cookie: this._cookieHeaderFor(cookies) } };
  }

  _cookieHeaderFor(allCookies) {
    // unfortunately the websocket client from k6 does not natively support cookies,
    // so we have to work around that issue by building the Cookie header ourselves
    let cookieHeader = "";
    for (const [_name, cookies] of Object.entries(allCookies)) {
      for (const cookie of cookies) {
        cookieHeader += ` ${cookie.name}=${cookie.value};`;
      }
    }
    return cookieHeader;
  }

  _parseBody(body) {
    let doc = parseHTML(body);
    let csrfToken = doc.find('meta[name="csrf-token"]').attr("content");

    let phxMain = doc.find('div[data-phx-main="true"]');
    let phxId = phxMain.attr("id");
    let phxSession = phxMain.attr("data-phx-session");
    let phxStatic = phxMain.attr("data-phx-static");

    return {
      csrfToken,
      phxMain,
      phxId,
      phxSession,
      phxStatic,
    };
  }
}
