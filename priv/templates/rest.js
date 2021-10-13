import http from "k6/http";
import { check, sleep } from "k6";

export default function () {
  const data = {};
  let res = http.post("<%= @url %>", data);
  check(res, { success: (r) => r.status === 200 });
  sleep(0.3);
}
