// netserver ips.

output "netserver_ips" {
    description ="the list of netserve IPs for each aws_netserv_az "
    value = ["${aws_instance.netserver.*.public_ip}"]
}

output "flent_ips" {
    description ="the list of netserve IPs for each aws_netserv_az "
    value = ["${aws_instance.flent.*.public_ip}"]
}