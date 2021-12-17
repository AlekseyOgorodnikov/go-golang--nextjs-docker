ARG GO_VERSION=1.17.5
ARG NODE_VERSION=16.13.1
ARG ALPINE_VERSION=3.13.5

FROM node:${NODE_VERSION}-alpine AS node-builder
WORKDIR /go-nextjs-docker
COPY nextjs/package.json nextjs/yarn.lock ./
RUN yarn install --frozen-lockfile
COPY nextjs/ .
ENV NEXT_TELEMETRY_DISABLED=1
RUN yarn run export

FROM golang:${GO_VERSION}-alpine AS go-builder
WORKDIR /go-nextjs-docker
COPY go.mod main.go ./
COPY --from=node-builder /go-nextjs-docker/dist ./nextjs/dist
RUN go build .

FROM alpine:${ALPINE_VERSION}
WORKDIR /go-nextjs-docker
COPY --from=go-builder /go-nextjs-docker/go-nextjs-docker .

ENTRYPOINT ["./go-nextjs-docker"]

EXPOSE 8080
