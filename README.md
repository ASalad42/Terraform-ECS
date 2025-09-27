# Simple Node.js frontend app running on ECS via CI/CD Pipeline

```txt
Client Browser (HTTPS:443)
    ↓ (TLS encrypted)
Internet
    ↓
[ ALB in Public Subnet ]
  ↳ SG: Allows 80/443 from 0.0.0.0/0
    ↓ (TLS termination at ALB)
ALB forwards HTTP:80
    ↓
Target Group (IP mode: ECS task ENIs)
    ↓
[ ECS Task ENI in Private Subnet ]
  ↳ SG: Allows port 80 **only from ALB SG**
    ↓
Node.js Container (listening on port 80)
    ↓
Response
    ↑
Back through ECS SG → ALB SG → ALB
    ↑ (TLS re-applied to client session)
Client Browser (HTTPS response)

```

- ECS Fargate Module: Cluster + Service + Task Definition + Logs all configured. Service attaches to target group
- ALB forwards to ECS tasks → tasks respond → ALB serves responses over HTTPS.
  - Route53 record resolves domain → ALB’s DNS name.
  - ACM cert issued for domain.
  - ALB listener (HTTPS with ACM cert) → forward rule → Target Group →  target type ip (Fargate tasks use awsvpc) → ECS Service (lb section) → Task ENI → containerPort → Container.
    - The container listens on the containerPort - Traffic forwarded by the ALB via the Target Group reaches the container on that port.
  - Response: Container → Task ENI → Target Group → ALB → HTTPS (re-encrypted to client)
- Security group: internet → ALB (443/80) → ECS tasks (80).
  - ALB SG allows HTTP (from_port → to_port = 80) and HTTPS (443).
  - ECS SG allows inbound from ALB SG on container port (80) - isolates ECS tasks so only ALB can talk to them.
- ACM module → issues the cert for domain.
  - frontend_alb → attaches that cert to the ALB listener.
  - route53 module → creates a record pointing to ALB.
- Nat Gateway - is in a public subnet and has an Elastic IP (EIP), so it can talk to the internet.
  - Forwards the traffic to the Internet Gateway (since the public subnet route table points to the IGW).
  - ECS → Private subnet → private route table → NAT Gateway → Internet Gateway → Internet

commands:

- `terraform init`
- `terraform validate`
- `terraform graph > graph.dot`
- `terraform plan -var-file="test.tfvars"`
- `terraform apply -var-file="test.tfvars"`
- `terraform destroy -var-file="test.tfvars"`

CICD:

- docker.yml builds app image and pushes to ECR
- deploy.yml manual trigger from github > run workflow > choose environment > run
- destroy.yml manual trigger also

| Git Branch | Docker Tag (ECR)            | Terraform Environment | terraform.tfvars `image_url` |
| ---------- | --------------------------- | --------------------- | ---------------------------- |
| `main`     | `test` / `test-<sha>`       | `test`                | `.../frontend:test`          |
| `staging`  | `staging` / `staging-<sha>` | `staging`             | `.../frontend:staging`       |
| `prod`     | `prod` / `prod-<sha>`       | `prod`                | `.../frontend:prod`          |

| Workflow Input / Trigger                           | Terraform Environment Directory  | TFVARS File                                       | AWS Backend                                         |
| -------------------------------------------------- | -------------------------------- | ------------------------------------------------- | --------------------------------------------------- |
| `workflow_dispatch` input: `environment = test`    | `terraform/environments/test`    | `terraform/environments/test/terraform.tfvars`    | `s3://devops/ecs/test/terraform.tfstate`    |
| `workflow_dispatch` input: `environment = staging` | `terraform/environments/staging` | `terraform/environments/staging/terraform.tfvars` | `s3://devops/ecs/staging/terraform.tfstate` |
| `workflow_dispatch` input: `environment = prod`    | `terraform/environments/prod`    | `terraform/environments/prod/terraform.tfvars`    | `s3://devops/ecs/prod/terraform.tfstate`    |

<img width="1903" height="847" alt="image" src="https://github.com/user-attachments/assets/3f9cd711-a117-45f5-aeec-126860bdf874" />
<img width="1896" height="847" alt="image" src="https://github.com/user-attachments/assets/807828eb-731c-4a32-87d8-3cd5108f11f5" />
<img width="1536" height="1024" alt="image" src="https://github.com/user-attachments/assets/5aa1520a-1665-421a-be21-5448edfe02f3" />
<img width="1833" height="542" alt="image" src="https://github.com/user-attachments/assets/d89992e1-3dd0-4ffd-b64f-b6622938615b" />
<img width="1627" height="411" alt="image" src="https://github.com/user-attachments/assets/0a0f69e3-78bc-451e-b41a-ce913593042e" />
<img width="1862" height="577" alt="image" src="https://github.com/user-attachments/assets/2d06d458-59b6-441e-9246-3e585718952d" />
<img width="1902" height="882" alt="image" src="https://github.com/user-attachments/assets/638bb495-1bfe-4069-b363-ae2498d85cd1" />