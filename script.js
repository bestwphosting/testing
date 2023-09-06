import http from 'k6/http';
import { sleep } from 'k6';

export const options = {
  vus: 10,
  duration: '5m',
};

export default function () {
  http.get(`${__ENV.URL}`);
  sleep(1);
}
