# Build the manager binary
FROM reg.docker.alibaba-inc.com/sigma/golang:1.11.9 as builder

# Copy in the go src
WORKDIR /go/src/gitlab.alipay-inc.com/antcloud-devops/cafeautoscaler
COPY cmd/    cmd/
COPY vendor/ vendor/
COPY pkg/    pkg/

# Build
RUN CGO_ENABLED=0 GOOS=linux GOARCH=amd64 go build -v -a -o autoscaler gitlab.alipay-inc.com/antcloud-devops/cafeautoscaler/cmd/autoscaler

# Copy the controller-manager into a thin image
FROM reg.docker.alibaba-inc.com/alipay/7u2-common:20181024171013-95b4128
WORKDIR /
COPY --from=builder /go/src/gitlab.alipay-inc.com/antcloud-devops/cafeautoscaler/autoscaler .
ENTRYPOINT ["/autoscaler"]
