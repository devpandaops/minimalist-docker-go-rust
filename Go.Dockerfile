#####################
#       BUILDER     #
#####################
FROM golang:alpine AS builder

RUN apk add --no-cache upx

ENV CGO_ENABLED=0 \
  GOOS=linux \
  GOARCH=amd64

WORKDIR /app

COPY ./src/http.go .

RUN go build \
  -trimpath \
  -ldflags="-s -w -extldflags '-static'" \
  -o /app/http \
  ./http.go

RUN upx --lzma /app/http

#####################
#     PRODUCTION    #
#####################
FROM scratch

ENV GIN_MODE=release
COPY --from=builder /app/http .

EXPOSE 8001

CMD ["./http"]
