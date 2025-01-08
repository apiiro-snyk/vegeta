FROM golang:1.20-alpine3.18 AS BUILD

RUN apk add make build-base git

WORKDIR /vegeta

# cache dependencies
ADD go.mod /vegeta
ADD go.sum /vegeta
RUN go mod download

ADD . /vegeta

RUN make generate
RUN make vegeta

FROM alpine:3.21.1

COPY --from=BUILD /vegeta/vegeta /bin/vegeta

ENTRYPOINT ["vegeta"]
