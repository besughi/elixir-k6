import http from "k6/http";
import { sleep } from "k6";

export default function () {
  let query = `
      query Query {
        field(arg: "arg") {
          data
        }
      }`;

  let headers = { "Content-Type": "application/json" };

  let res = http.post("<%= @url %>", JSON.stringify({ query: query }), {
    headers: headers,
  });

  sleep(0.3);
}
