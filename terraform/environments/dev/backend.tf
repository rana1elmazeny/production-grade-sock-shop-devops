terraform {
  backend "s3" {
    bucket         = "ranaelmazeny-sockshop-terraform-state-2026"
    key            = "dev/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "sockshop-terraform-locks"
    encrypt        = true
  }
}
