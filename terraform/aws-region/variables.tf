// azs
variable environment {
    type = "string"
    default = ""
}

variable "aws_flent_azs" {
    type = "list"
    default = []
}

variable "aws_netserver_azs" {
    type = "list"
    default = []
}

variable "netserver_userdata"  {
    type="string"
}

variable "flent_userdata"  {
    type="string"
}

