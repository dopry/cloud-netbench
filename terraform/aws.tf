

// default AWS region
provider "aws" {
  // use the environment variables AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY to configure.
  region = "us-east-1"
}

// Named alias regions.
provider "aws" {
  // use the environment variables AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY to configure.
  alias = "us-east-1"
  region = "us-east-1"
}

provider "aws" {
  alias = "us-west-1"
  region = "us-west-1"
}

provider "aws" {
  alias = "eu-central-1"
  region = "eu-central-1"
}

provider "aws" {
  alias = "ap-southeast-1"
  region = "ap-southeast-1"
}

module "aws_us-east-1" {
    source = "./aws-region"
    providers = {
        aws = "aws.us-east-1"
    }

    environment = "${var.environment}"
    aws_netserver_azs = ["${var.aws_netserver_azs_us_east_1}"]
    aws_flent_azs = ["${var.aws_flent_azs_us_east_1}"]
    netserver_userdata = "${data.template_cloudinit_config.common_netserver.rendered}"
    flent_userdata = "${data.template_cloudinit_config.common_flent.rendered}"
}

module "aws_us-west-1" {
    source = "./aws-region"
    providers = {
        aws = "aws.us-west-1"
    }

    environment = "${var.environment}"
    aws_netserver_azs = ["${var.aws_netserver_azs_us_west_1}"]
    aws_flent_azs = ["${var.aws_flent_azs_us_west_1}"]
    netserver_userdata = "${data.template_cloudinit_config.common_netserver.rendered}"
    flent_userdata = "${data.template_cloudinit_config.common_flent.rendered}"
}

module "aws_eu-central-1" {
    source = "./aws-region"
    providers = {
        aws = "aws.eu-central-1"
    }

    environment = "${var.environment}"
    aws_netserver_azs = ["${var.aws_netserver_azs_eu_central_1}"]
    aws_flent_azs = ["${var.aws_flent_azs_eu_central_1}"]
    netserver_userdata = "${data.template_cloudinit_config.common_netserver.rendered}"
    flent_userdata = "${data.template_cloudinit_config.common_flent.rendered}"
}

module "aws_ap-southeast-1" {
    source = "./aws-region"
    providers = {
        aws = "aws.ap-southeast-1"
    }

    environment = "${var.environment}"
    aws_netserver_azs = ["${var.aws_netserver_azs_ap_southeast_1}"]
    aws_flent_azs = ["${var.aws_flent_azs_ap_southeast_1}"]
    netserver_userdata = "${data.template_cloudinit_config.common_netserver.rendered}"
    flent_userdata = "${data.template_cloudinit_config.common_flent.rendered}"
}
