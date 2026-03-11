terraform {
  backend "s3" {
    bucket         = "my-tf-test-bucket-2082026"
    key            = "minikube/terraform.tfstate"
    region         = "eu-north-1"
    dynamodb_table = "backend_terrform-statelock"
    encrypt        = true
  }
}
