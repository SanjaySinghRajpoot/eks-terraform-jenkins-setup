terraform {
    backend "s3" {
        bucket = "terraform-jenkins-test-12345"
        key = "jenkins/terraform.tfstate"
        region = "ap-south-1"
    }
}