terraform {
  backend "gcs" {
    bucket = "<seu-bucket-terraform>"
    prefix = "desafio-opahit/state"
  }
}
