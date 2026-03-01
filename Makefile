AWS_REGION ?= us-east-1
SERVICE_A_IMAGE ?= service_a:latest
SERVICE_B_IMAGE ?= service_b:latest
SERVICE_A_DOCKERFILE = services/service_a/Dockerfile
SERVICE_B_DOCKERFILE = services/service_b/Dockerfile
DOCKER_CONTEXT = services

.PHONY: all infra ecr-login build push clean

all: infra build push

infra:
	cd infra && terraform init && terraform apply -auto-approve

ecr-login:
	@aws ecr get-login-password --region $(AWS_REGION) | \
	docker login --username AWS --password-stdin $$(aws sts get-caller-identity --query 'Account' --output text).dkr.ecr.$(AWS_REGION).amazonaws.com

build:
	docker build -t $(SERVICE_A_IMAGE) -f $(SERVICE_A_DOCKERFILE) $(DOCKER_CONTEXT)
	docker build -t $(SERVICE_B_IMAGE) -f $(SERVICE_B_DOCKERFILE) $(DOCKER_CONTEXT)

push:
	@echo "Pushing images to ECR. Set ECR_A_URI and ECR_B_URI as env vars or edit Makefile."
	docker tag $(SERVICE_A_IMAGE) $(ECR_A_URI)
	docker tag $(SERVICE_B_IMAGE) $(ECR_B_URI)
	docker push $(ECR_A_URI)
	docker push $(ECR_B_URI)

clean:
	rm -rf infra/.terraform
	rm -rf infra/terraform.tfstate*
