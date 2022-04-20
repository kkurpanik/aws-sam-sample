output "idmz-vpc-arn" {
    description = "ARN of the idmz vpc."
    value = aws_vpc.idmz-vpc.arn
}

output "idmz-private-subnet-a-arn" {
    description = "ARN of idmz public subnet a"
    value = aws_subnet.idmz-private-subnet-a.arn
}

output "idmz-private-subnet-b-arn" {
    description = "ARN of idmz public subnet b"
    value = aws_subnet.idmz-private-subnet-b.arn
}