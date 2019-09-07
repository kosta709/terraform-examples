## Example: Reference resource from other configuration

### The use case:
- There are two aws security groups:
  - sec-group-a which is managed by terraform state-a
  - sec-group-b which is managed by terraform state-b
- sec-group-b should have inbound rule to allow access to port 22 from sec-group-a
- the id of sec-group-a is unknown

### Solution:
We will use 
https://www.terraform.io/docs/providers/terraform/d/remote_state.html

state-a should exposes the id of sec-group-a as an output
state-b gets backend config of state-a as a variable and uses 

```
ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    security_groups = [data.terraform_remote_state.sg_ssh_allowed_reference.outputs.sec_group_id]
  }
```

### Try it:

Create sec-group-a
```bash
# 1. apply state-a - it will create sec-group-a in default vpc
terraform init state-a
terraform plan state-a
terraform apply state-a
```

Create sec-group-b
```bash
# 2. apply state-b - it will create sec-group-b with ingress rule to allow port-22 from sec-group-a
terraform init state-b
terraform plan state-b
terraform apply state-b
```




