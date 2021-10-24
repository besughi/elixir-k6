import http from "k6/http";
import { sleep } from "k6";

// See https://k6.io/docs/using-k6/options/#using-options for documentation on k6 options
export const options = {
  vus: 10,
  duration: '30s',
};

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
