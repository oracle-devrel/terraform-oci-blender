# Copyright (c) 2021 Oracle and/or its affiliates.

resource "oci_core_instance" "blender" {
  availability_domain = data.oci_identity_availability_domains.ads.availability_domains[0].name
  compartment_id      = var.compartment_ocid
  display_name        = "blender"
  shape               = local.compute_shape

  create_vnic_details {
    assign_private_dns_record = true
    assign_public_ip          = true
    display_name              = "blender"
    hostname_label            = "blender"
    nsg_ids = [
      oci_core_network_security_group.blender.id
    ]
    skip_source_dest_check = false
    subnet_id              = oci_core_subnet.this.id
  }
  metadata = {
    ssh_authorized_keys = local.ssh_public_keys
  }
  source_details {
    source_id   = local.compute_image_id
    source_type = "image"

    boot_volume_size_in_gbs = 50
  }
  preserve_boot_volume = false

  lifecycle {
    ignore_changes = [defined_tags["Oracle-Tags.CreatedBy"], defined_tags["Oracle-Tags.CreatedOn"]]
  }
  defined_tags = {
    "${oci_identity_tag_namespace.devrel.name}.${oci_identity_tag.release.name}" = local.release
  }

  provisioner "remote-exec" {
    inline = [
      "sudo dnf update -y",
      "sudo dnf groupinstall -y \"Server with GUI\"",
      "sudo dnf install -y tigervnc-server",
      "sudo systemctl set-default graphical.target",
      "sudo ln -sf /lib/systemd/system/runlevel5.target /etc/systemd/system/default.target",
      # credit to: https://stackoverflow.com/questions/2854655/command-to-escape-a-string-in-bash for this...
      "printf \"%s\n%s\n\n\" `printf \"%q\" '${var.opc_passwd}'` `printf \"%q\" '${var.opc_passwd}'` | passwd opc",
      "printf \"%s\n%s\n\n\" `printf \"%q\" '${var.vnc_passwd}'` `printf \"%q\" '${var.vnc_passwd}'` | vncpasswd",
      "sudo sh -c \"echo \":1=opc\" >> /etc/tigervnc/vncserver.users\"",
      "sudo systemctl start vncserver@:1",
      "sudo systemctl enable vncserver@:1",
      "wget -O /home/opc/${local.blender_file_name} ${var.blender_url}",
      "tar -xvf /home/opc/${local.blender_file_name} -C /home/opc",
      "echo \"PATH=$PATH:/home/opc/${local.blender_dir}/\" >> /home/opc/.bashrc",
      "echo \"export PATH\" >> /home/opc/.bashrc",
    ]

    connection {
      private_key = tls_private_key.this.private_key_pem
      user        = "opc"
      host        = self.public_ip
    }
  }
}
