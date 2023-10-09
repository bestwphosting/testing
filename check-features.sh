#!/bin/sh
HOST=$1

echo "BROTLI: " $(curl https://$HOST -H "Accept-Encoding: br" --dump-header - -o /dev/null --silent | grep -i content-encoding)
echo "GZIP: " $(curl https://$HOST -H "Accept-Encoding: gzip" --dump-header - -o /dev/null --silent |grep -i content-encoding)
echo "HTTP/3: " $(curl https://$HOST --dump-header - -o /dev/null --silent | grep alt-svc)
echo "HTTP VERSION: " $(curl -sI https://$HOST -o/dev/null -w '%{http_version}\n')
