# Stage 1: Build the Go binary
FROM golang:1.18-alpine AS builder

WORKDIR /app

COPY go.mod go.sum ./
RUN go mod download

COPY . ./
RUN protoc --go_out=. --go-grpc_out=. proto/service1.proto
RUN go build -o service1 .

# Stage 2: Create the final lightweight image
FROM alpine:latest

WORKDIR /

COPY --from=builder /app/service1 /service1

EXPOSE 50051

CMD ["/service1"]