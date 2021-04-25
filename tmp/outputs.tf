output "ubuntu_public_ip" {
  value = aws_instance.ubusrv01.public_ip
}

output "ubuntu_host_name" {
  value = aws_instance.ubusrv01.public_dns
}
output "ubuntu_private_ip" {
  value = aws_instance.ubusrv01.private_ip
}

output "ubuntu_AZ" {
  value = aws_instance.ubusrv01.availability_zone
}

output "ubuntu_instance_id" {
  value = aws_instance.ubusrv01.id
}


output "amz_public_ip" {
  value = aws_instance.amzsrv01.public_ip
}

output "amz_host_name" {
  value = aws_instance.amzsrv01.public_dns
}
output "amz_private_ip" {
  value = aws_instance.amzsrv01.private_ip
}

output "amz_AZ" {
  value = aws_instance.amzsrv01.availability_zone
}

output "amz_instance_id" {
  value = aws_instance.amzsrv01.id
}