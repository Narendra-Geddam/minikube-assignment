# Ansible configuration

This playbook configures the EC2 instance created by Terraform as a single-node Minikube host and installs Helm.

## Run locally

```powershell
cd infra
terraform init
terraform apply -var-file="terraform.tfvars"

cd ../ansible
ansible-playbook playbook.yml
```

## Remote Minikube API access

The playbook also prepares Minikube for access from another machine through an SSH tunnel.

Implemented behavior:

1. Minikube starts with API SANs for public IP and localhost (`--apiserver-ips=<public-ip>,127.0.0.1`).
2. `minikube update-context` is run on EC2 to keep host-side kubectl healthy.
3. A flattened kubeconfig is generated at `/home/ec2-user/kubeconfig-tunnel.yaml`.
4. Tunnel kubeconfig server endpoint is set to `https://127.0.0.1:8443`.
5. The kubeconfig is fetched to `ansible/artifacts/kubeconfig-tunnel-<host-ip>.yaml`.
6. A systemd service (`minikube-nodeport-expose.service`) exposes NodePort range `30000-32767` on EC2 public interface.

## Using kubeconfig from another machine

1. Get `ansible/artifacts/kubeconfig-tunnel-<host-ip>.yaml` from local run output or Jenkins artifact.
2. Open tunnel:

```bash
MINIKUBE_IP=$(ssh -i <private-key.pem> ec2-user@<ec2-public-ip> "minikube ip")
ssh -i <private-key.pem> -o ExitOnForwardFailure=yes -N -L 8443:${MINIKUBE_IP}:8443 ec2-user@<ec2-public-ip>
```

3. Run:

```bash
kubectl --kubeconfig kubeconfig-tunnel-<host-ip>.yaml get nodes
```

## Access app via public IP (NodePort)

If your service is NodePort `30081`, access it directly from outside:

```text
http://<ec2-public-ip>:30081
```

No per-app SSH tunnel is needed for NodePort services after this playbook runs.
