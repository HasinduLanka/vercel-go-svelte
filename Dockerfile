FROM golang:alpine AS builder

RUN apk add git

# Set necessary environmet variables needed for our image
ENV GO111MODULE=on \
    CGO_ENABLED=0 \
    GOOS=linux \
    GOARCH=amd64

# Move to working directory /src
WORKDIR /src

COPY go.mod ./
RUN go mod download && go mod verify

# Copy the code into the container
COPY . .

RUN go mod tidy

# Run test
RUN go test -v ./...

# Build the application
RUN go build -o main .

# Move to /dist directory as the place for resulting binary folder
WORKDIR /dist

# Copy binary from build to main folder
RUN cp /src/main .
RUN cp -r /src/frontend ./frontend

############################
# STEP 2 build a small image
############################
FROM scratch

COPY --from=builder /dist/ /

EXPOSE 20000

# Command to run the executable
ENTRYPOINT ["/main"]
