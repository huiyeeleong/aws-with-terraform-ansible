terraform {
    required_version = ">=0.2.0"
    backend "s3" {
    region = "us-east-1"
    profile = "default"
    key = "terraformstatefile"
    bucket = "terraformbuckethui"
    }
}