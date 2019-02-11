
variable "environment" {
    type = "string"
    default = "netbench"
}

variable "bgp_credentials" {
    type = "string"
    default = "L3B4ndidtO5"
}

// list all the locations where netservers should run for each provider.
// these should be the resource in which an instance is deployed for each supported
// provider.

variable "aws_netserver_azs_ap_southeast_1" {
    type = "list"
    default = []
}

variable "aws_netserver_azs_eu_central_1" {
    type = "list"
    default = ["eu-central-1a"]
}

variable "aws_netserver_azs_us_east_1" {
    type = "list"
    default = ["us-east-1c"]
}

variable "aws_netserver_azs_us_west_1" {
    type = "list"
    default = ["us-west-1c"]
}

variable "packet_netserver_dcs" {
    type = "list"
    default = []
}

// list all the locations from which we want to take latency measures. Each flent location
// will mwaure latency to each netserver.
variable "aws_flent_azs_ap_southeast_1" {
    type = "list"
    default = []
}

variable "aws_flent_azs_eu_central_1" {
    type = "list"
    default = []
}

variable "aws_flent_azs_us_east_1" {
    type = "list"
    default = []
}

variable "aws_flent_azs_us_west_1" {
    type = "list"
    default = []
}

variable "packet_flent_dcs" {
    type = "list"
    default = [ "ewr1", "sjc1", "ams1" ]
}