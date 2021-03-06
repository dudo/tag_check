FROM bash

LABEL version="1.1.1"

RUN apk --no-cache add jq curl grep

COPY Dockerfile /
COPY entrypoint.sh /

ENTRYPOINT ["bash"]

CMD ["/entrypoint.sh"]
