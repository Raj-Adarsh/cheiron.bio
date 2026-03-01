# DevOps AWS Infrastructure Project

## Architecture Overview

This project provisions a highly available, auto-scaled web application infrastructure on AWS using Terraform. The architecture includes:

- **VPC** with two public subnets in different Availability Zones
- **Application Load Balancer (ALB)** for HTTP traffic
- **Auto Scaling Group (ASG)** of EC2 instances
- **ECR** repositories for Docker images
- **IAM** roles and security groups

### Architecture Diagram

```
+-------------------+         +-------------------+
|   Public Subnet A |         |   Public Subnet B |
|  (us-west-2a)     |         |  (us-west-2b)     |
|                   |         |                   |
|   +-----------+   |         |   +-----------+   |
|   |   EC2     |   |         |   |   EC2     |   |
|   +-----------+   |         |   +-----------+   |
+--------|----------+         +--------|----------+
         |                           |
         |                           |
         +-----------+---------------+
                     |
             +----------------+
             |    ALB         |
             +----------------+
                     |
             +----------------+
             |   Internet     |
             +----------------+
```

## AWS Region

- **Region Used:** `us-west-2`

## Deployment Steps

1. **Clone the repository:**
   ```sh
   git clone <your-repo-url>
   cd devops/infra
   ```

2. **Configure AWS credentials:**
   Ensure your AWS CLI is configured with a profile matching `aws_profile` in `terraform.tfvars` (default: `infra`).

3. **Edit variables:**
   - Update `terraform.tfvars` with your desired values (VPC CIDRs, key pair, AMI, etc).

4. **Initialize Terraform:**
   ```sh
   terraform init
   ```

5. **Apply the Terraform plan:**
   ```sh
   terraform apply -var-file="terraform.tfvars"
   ```

6. **Build and push Docker images:**
   - Tag and push your service images to the ECR repositories created by Terraform.

7. **Verify deployment:**
   - Find the ALB DNS name from the AWS Console or Terraform output.
   - Test endpoints:
     ```sh
     curl http://<alb-dns-name>/service_a
     curl http://<alb-dns-name>/service_b
     ```

## Running the Verification Script

A script `verify_services.sh` is provided in the `services/` directory to check the health of your deployed services.

1. Make the script executable:
   ```sh
   chmod +x services/verify_services.sh
   ```
2. Run the script, passing your ALB DNS name:
   ```sh
   ./services/verify_services.sh <alb-dns-name>
   ```

---

**Note:**
- Ensure your EC2 instances are healthy and registered in the ALB target groups.
- Security groups must allow traffic from the ALB to the application ports.
- For HTTPS, update the configuration to provide a valid ACM certificate.
