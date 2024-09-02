package main

import (
	"context"
	"log"
	"net"

	"google.golang.org/grpc"
	pb "service2/proto"
)

type server struct {
	pb.UnimplementedService2Server
}

func (s *server) GetData(ctx context.Context, in *pb.DataRequest) (*pb.DataReply, error) {
	return &pb.DataReply{Message: "Data: " + in.Query}, nil
}

func main() {
	lis, err := net.Listen("tcp", ":50052")
	if err != nil {
		log.Fatalf("failed to listen: %v", err)
	}
	s := grpc.NewServer()
	pb.RegisterService2Server(s, &server{})
	log.Printf("Server listening on port 50052")
	if err := s.Serve(lis); err != nil {
		log.Fatalf("failed to serve: %v", err)
	}
}