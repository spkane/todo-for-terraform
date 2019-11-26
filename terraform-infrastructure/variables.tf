variable "aws_profile" {
    description = "AWS Profile for credentials"
    default = "oreilly-aws"
}

variable "ssh_private_key_path" {
    description = "Path to EC2 SSH private key"
    default = "/Users/skane/.ssh/oreilly_aws"
}

variable "ssh_public_key_path" {
    description = "Path to EC2 SSH public key"
    default = "/Users/skane/.ssh/oreilly_aws.pub"
}

variable "personal_ns1_apikey" {
    description = "Personal NS1 API key"
}
