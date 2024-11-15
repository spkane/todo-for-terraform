variable "aws_profile" {
    type = string
    description = "AWS Profile for credentials"
    default = "oreilly-aws"
}

variable "ssh_private_key_path" {
    type = string
    description = "Path to EC2 SSH private key"
    default = "/Users/spkane/.ssh/oreilly_aws"
}

variable "ssh_public_key_path" {
    type = string
    description = "Path to EC2 SSH public key"
    default = "/Users/spkane/.ssh/oreilly_aws.pub"
}

variable "personal_ns1_apikey" {
    type = string
    description = "Personal NS1 API key"
    sensitive = true
}
