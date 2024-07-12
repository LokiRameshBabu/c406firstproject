# outputs.tf

# Output the key name
output "key_name" {
  value = aws_key_pair.generated_key.key_name
}

# Output the private key
output "private_key" {
  value     = tls_private_key.my_key.private_key_pem
  sensitive = true
}

# Output the instance public IP
output "instance_public_ip" {
  value = aws_instance.my_instance.public_ip
}