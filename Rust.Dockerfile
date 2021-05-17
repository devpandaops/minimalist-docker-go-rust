#####################
#       BUILDER     #
#####################
FROM rust:1.52.1-alpine AS builder

RUN apk add --no-cache upx

WORKDIR /app

RUN rustup target add x86_64-unknown-linux-musl

COPY . .

RUN cargo install --target x86_64-unknown-linux-musl --path .

RUN upx --lzma /usr/local/cargo/bin/http

#####################
#     PRODUCTION    #
#####################
FROM alpine

ENV GIN_MODE=release
COPY --from=builder /usr/local/cargo/bin/http .

EXPOSE 8002

CMD ["./http"]
