# Stage 1: Build the Go binary
FROM golang:1.18-alpine AS builder

WORKDIR /app

COPY go.mod go.sum ./
RUN go mod download

COPY . ./
RUN protoc --go_out=. --go-grpc_out=. proto/service2.proto
RUN go build -o service2 .

# Stage 2: Create the final lightweight image
FROM alpine:latest

WORKDIR /

COPY --from=builder /app/service2 /service2

EXPOSE 50052

CMD ["/service2"]