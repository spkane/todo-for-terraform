data "external" "public_ip" {
  program = ["./bin/local-ip.sh"]
}

data "terraform_remote_state" "training_account" {
  backend = "s3"
  config = {
    profile = "spkane-training"
    bucket = "spkane-training-tfstate"
    key    = "core/training-account.tfstate"
    region = "us-east-1"
   }
}