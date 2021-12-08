# Copyright (c) 2021 Oracle and/or its affiliates.

output "pub_ip" {
  value = oci_core_instance.blender.public_ip
}

output "ssh_cmd" {
  value = "ssh opc@${oci_core_instance.blender.public_ip} -L 5901:localhost:5901"
}

output "macos_finder_vnc_connect_string" {
  value = "vnc://localhost:5901"
}