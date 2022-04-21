output "idmz-vpc-arn" {
    description = "ARN of the idmz vpc."
    value = aws_vpc.idmz-vpc.arn
}

output "idmz-private-subnet-ids" {
    description = "IDs of idmz private subnets"
    value = aws_ssm_parameter.idmz-private-subnet-ids
    sensitive = true
}