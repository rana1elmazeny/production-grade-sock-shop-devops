output "vpc_id" {
  value = aws_vpc.sockshop_vpc.id
}

output "public_subnet_ids" {
  value = aws_subnet.public_subnets[*].id
}

output "private_subnet_ids" {
  value = aws_subnet.private_subnets[*].id
}
output "bastion_public_ip" {
  value = aws_instance.bastion.public_ip
}

output "sonarqube_public_ip" {
  value = aws_instance.sonarqube.public_ip
}
output "ecr_frontend_repository_url" {
  value = aws_ecr_repository.sockshop_frontend.repository_url
}
output "jenkins_public_ip" {
  value = aws_instance.jenkins.public_ip
}
