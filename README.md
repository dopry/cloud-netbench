# IAC Cloud Netbench

This terraform project runs network benchmarks across multiple cloud providers. It current only supports
[Packet](http://packet.com/) and a small subset of AWS regions (ap-southeast-1, us-east-1, us-west-1, eu-central-1)

## Folder Hierarchy

* /terraform/ - terraform definition of the remote environment

## Configuration

Please configure through environment variables, rather than changing internal code.


### Required

* Packet Credentials

  ```
  $Env:PACKET_AUTH_TOKEN="..."
  ```

* AWS Credentials

  ```
  $Env:AWS_ACCESS_KEY_ID="..."
  $Env:AWS_SECRET_ACCESS_KEY="..."
  ```

* Add your user to templates/common.cloud-config with ssh public key.

### Recommended

* environment identifier

  uniquely identify resources in all servces.
  ```
  $Env:TF_VAR_environment="..."
  ```


## Quickstat
```
# you'll need to update this file with your keys.
./environment.example.sh
./terraform apply
```