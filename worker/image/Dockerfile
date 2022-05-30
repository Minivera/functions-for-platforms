FROM andreburgaud/d8 as v8

RUN ls /v8

FROM golang:buster as build

WORKDIR /binary
COPY *.go /binary/

RUN go mod init github.com/fission/environments/binary
RUN go mod tidy

RUN go build -o server .

FROM debian:stable-slim

RUN mkdir /v8

COPY --from=v8 /v8/* /v8

WORKDIR /app

RUN apt-get update -y && \
    apt-get install coreutils binutils findutils grep -y && \
    apt-get clean

COPY --from=build /binary/server /app/server

EXPOSE 8888
ENTRYPOINT ["./server"]

