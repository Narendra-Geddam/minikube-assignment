output "instance_id" {
  description = "EC2 instance ID."
  value       = aws_instance.minikube.id
}

output "public_ip" {
  description = "Public IP address of the Minikube host."
  value       = aws_instance.minikube.public_ip
}

output "inventory_file" {
  description = "Generated Ansible inventory file."
  value       = local_file.ansible_inventory.filename
}
