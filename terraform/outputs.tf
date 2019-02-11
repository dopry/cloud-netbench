output "flent_ips" {
    description ="the list of all flent IPs, ssh to all of these to get your results."
    value = ["${concat(
        module.aws_ap-southeast-1.flent_ips,
        module.aws_eu-central-1.flent_ips,
        module.aws_us-east-1.flent_ips,
        module.aws_us-west-1.flent_ips,
        packet_device.flent.*.network.0.address
    )}"]
}
