import http from 'k6/http';
import { sleep } from 'k6';

export const options = {
  vus: 1,
  duration: '1s',
};

export default function () {
  http.get(`${__ENV.URL}`);
  sleep(1);
}

export function handleSummary(data) {
  const durations = data.metrics.http_req_duration.values;
  const fails = data.metrics.http_req_failed.values;

  return {
    'summary.csv': `${durations.min},${durations.max},${durations.avg},${fails.fails},${fails.passes},${fails.rate}`,
  };
}
