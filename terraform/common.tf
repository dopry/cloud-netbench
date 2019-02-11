// config and setup use across all providers/regions/dcs.

data "template_file" "common_cloud_config" {
    template = "${file("${path.module}/templates/common.cloud-config")}"
}

locals {

    netserver_zones = "${concat(
        var.aws_netserver_azs_ap_southeast_1,
        var.aws_netserver_azs_eu_central_1,
        var.aws_netserver_azs_us_east_1,
        var.aws_netserver_azs_us_west_1,
        var.packet_netserver_dcs,
    )}"

    netserver_addresses = "${concat(
        module.aws_ap-southeast-1.netserver_ips,
        module.aws_eu-central-1.netserver_ips,
        module.aws_us-east-1.netserver_ips,
        module.aws_us-west-1.netserver_ips,
        packet_device.netserver.*.network.0.address
    )}"

}


data "template_file" "common_netserver_init" {
    template = "${file("${path.module}/templates/netserver-init.sh")}"
}

data "template_cloudinit_config" "common_netserver" {
    gzip = false
    base64_encode = false

    part {
        content_type = "text/cloud-config"
        content = "${data.template_file.common_cloud_config.rendered}"
    }

    part {
        content_type = "text/x-shellscript"
        content = "${data.template_file.common_netserver_init.*.rendered[count.index]}"
    }
}

// FLENT latency measurement servers
data "template_file" "common_flent_init" {
    template = "${file("${path.module}/templates/flent-init.sh")}"

    vars = {
       NETSERVER_ADDRESSES = "${join("\n", local.netserver_addresses )}"
       NETSERVER_ZONES = "${join("\n", local.netserver_zones)}"
    }
}

data "template_cloudinit_config" "common_flent" {
    gzip = false
    base64_encode = false

    part {
        content_type = "text/cloud-config"
        content = "${data.template_file.common_cloud_config.rendered}"
    }

    part {
        content_type = "text/x-shellscript"
        content = "${data.template_file.common_flent_init.*.rendered[count.index]}"
    }
}

