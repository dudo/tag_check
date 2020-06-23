FROM bash

RUN apk --no-cache add jq curl grep

COPY entrypoint.sh /

ENTRYPOINT ["/entrypoint.sh"]
