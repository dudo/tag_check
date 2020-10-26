FROM bash

LABEL version="1.0.2"

RUN apk --no-cache add jq curl grep

COPY Dockerfile /
COPY entrypoint.sh /

ENTRYPOINT ["bash"]

CMD ["/entrypoint.sh"]
