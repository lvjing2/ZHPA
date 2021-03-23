
GIT_COMMIT = $(shell git log -1 --pretty=format:%h)
BUILD_DATE = $(shell date +%Y%m%d)
IMAGE_TAG = ${GIT_COMMIT}-${BUILD_DATE}

# Image URL to use all building/pushing image targets
CONTROLLER_IMAGE ?= reg.docker.alibaba-inc.com/antcloud-devops/cafeautoscaler-controller:${IMAGE_TAG}

all: test build

# Run tests
test: generate fmt vet
	go test ./pkg/... ./cmd/... -coverprofile cover.out

# Build manager binary
build: fmt vet
	go build -v -o bin/autoscaler gitlab.alipay-inc.com/antcloud-devops/cafeautoscaler/cmd/autoscaler

# Run against the configured Kubernetes cluster in ~/.kube/config
run: fmt vet
	go run ./cmd/autoscaler/main.go

# Install CRDs into a cluster
# !!! Only can do in your test cluster, you do not have rights to apply files in partner-resources to Sigma
install:
	kubectl apply -f ./config/partner-resources/hpa-controller

# Deploy controller in the configured Kubernetes cluster in ~/.kube/config
# !!! Only can do in your test cluster, you do not have rights to apply files in partner-resources to Sigma
deploy:
	kubectl apply -f ./config/partner-resources/hpa-controller
	kubectl apply -f ./config/deploy/

# Run go fmt against code
fmt:
	go fmt ./pkg/... ./cmd/...

# Run go vet against code
vet:
	go vet ./pkg/... ./cmd/...

yaml:
	go run hack/make-kustomize-overlays/make-kustomize.go
	kustomize/make.sh

# Generate code
generate:
ifndef GOPATH
	$(error GOPATH not defined, please define GOPATH. Run "go help gopath" to learn more about GOPATH)
endif
	go generate ./pkg/... ./cmd/...

# Build the mananger docker image
docker-build-manager: test
	docker build . -f Dockerfile -t ${CONTROLLER_IMAGE}
	@echo "updating deploy file for manager controller"
	sed -i'' -e 's@image: .*@image: '"${CONTROLLER_IMAGE}"'@' ./config/deploy/manager.yaml
	docker push ${CONTROLLER_IMAGE}

# Push the docker image
docker-push:
	docker push ${CONTROLLER_IMAGE}
