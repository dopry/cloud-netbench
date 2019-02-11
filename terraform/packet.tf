# Configure the Packet Provider
provider "packet" {
  // Use then evironment variable PACKET_AUTH_TOKEN instead.
  // auth_token = "${var.auth_token}"
}

resource "packet_project" "environment" {
    name = "${var.environment}"
}

resource "packet_device" "netserver" {
   count            = "${length(var.packet_netserver_dcs)}"
   hostname         = "${format("netserver-packet-%s", var.packet_netserver_dcs[count.index])}"
   plan             = "t1.small.x86"
   facility         = "${var.packet_netserver_dcs[count.index]}"
   // xenial 16.04 was the base for the packer images at the time of this writing.
   operating_system = "ubuntu_18_04"
   billing_cycle    = "hourly"
   project_id       = "${packet_project.environment.id}"
   // netserver configs are a list of concat (var.aws_netserver_azs, var.packet_netserver_dcs)
   user_data        = "${data.template_cloudinit_config.common_netserver.rendered[count.index]}"
   tags             = ["service/netserver", "env/${var.environment}"]
}


resource "packet_device" "flent" {
   count            = "${length(var.packet_flent_dcs)}"
   hostname         = "${format("flent-packet-%s", var.packet_flent_dcs[count.index])}"
   plan             = "t1.small.x86"
   facility         = "${var.packet_flent_dcs[count.index]}"
   // xenial 16.04 was the base for the packer images at the time of this writing.
   operating_system = "ubuntu_18_04"
   billing_cycle    = "hourly"
   project_id       = "${packet_project.environment.id}"
   user_data        = "${data.template_cloudinit_config.common_flent.rendered}"
   tags             = ["service/flent", "env/${var.environment}"]
}