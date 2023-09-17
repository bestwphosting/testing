import http from 'k6/http';
import { sleep } from 'k6';

export const options = {
  vus: 50,
  duration: '5m',
};

export default function () {
  http.get(`${__ENV.URL}`);
  sleep(1);
}

export function handleSummary(data) {
  const durations = data.metrics.http_req_duration.values;
  const fails = data.metrics.http_req_failed.values;

  // summary fails and passes should really be the other way around
  // https://github.com/grafana/k6/issues/2306
  return {
    'summary.csv': `http_req_duration_min,http_req_duration_max,http_req_duration_avg,http_req_failed_fails,http_req_failed_passes,http_req_failed_rate
${durations.min},${durations.max},${durations.avg},${fails.fails},${fails.passes},${fails.rate}`,
  };
}
