terraform {
  backend "s3" {
    bucket = "lpg-terraform"
    key    = "bob/"
    region = "eu-west-1"
    access_key = "AKIAJECLMIR7MVGQPSGQ"
    secret_key = "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"
  }
}