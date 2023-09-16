import http from 'k6/http';
import { sleep } from 'k6';

export const options = {
  vus: 50,
  duration: '10m',
};

export default function () {
  http.get(`${__ENV.URL}`);
  sleep(1);
}
