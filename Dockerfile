FROM ubuntu:20.04 as builder

ARG OPTIMIZE_FOR_PORTABILITY

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
  && apt install -y --no-install-recommends ca-certificates g++ cmake wget make zlib1g-dev \
  && wget https://github.com/shubhamchandak94/Spring/archive/refs/tags/v1.1.1.tar.gz \
  && tar xvzf v1.1.1.tar.gz \
  && cd Spring-1.1.1 \
  && mkdir build \
  && cd build/ \
  && cmake .. -Dspring_optimize_for_portability=${OPTIMIZE_FOR_PORTABILITY} \
  && make

FROM ubuntu:20.04

LABEL org.opencontainers.image.title="Docker image for Spring"
LABEL org.opencontainers.image.authors="Julien FOURET"
LABEL org.opencontainers.image.description="https://github.com/shubhamchandak94/Spring"
LABEL org.opencontainers.image.vendor="Nexomis"
LABEL org.opencontainers.image.licenses="Apache-2.0"

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
  && apt-get install -y --no-install-recommends zlib1g libgomp1 \
  && rm -rf /var/lib/apt/lists/*

COPY --from=builder /Spring-1.1.1/build/spring /usr/local/bin/spring

ENTRYPOINT [""]
