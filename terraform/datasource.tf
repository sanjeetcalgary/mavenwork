data "aws_ami" "amzami" {
  most_recent = true
  owners = [ "amazon", "self" ]

    filter {
        name = "name"
        values = [ "Amazon Linux 2023 *" ]
    }
  
    filter {
        name = "root-device-type"
        values = [ "ebs" ]
    }

    filter {
        name = "virtualization-type"
        values = [ "hvm" ]
    }

    filter {
        name = "architecture"
        values = [ "x86_64" ]
    }
}