output "vpc" {
  value = aws_vpc.default.*
}
output "public-subnets" {
  value = [aws_subnet.public-1.id, aws_subnet.public-2.id, aws_subnet.public-3.id]
}
output "private-subnets" {
  value = [aws_subnet.private-1.id, aws_subnet.private-2.id, aws_subnet.private-3.id]
}