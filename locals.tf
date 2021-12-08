# Copyright (c) 2021 Oracle and/or its affiliates.

locals {
  nsg_types = {
    cidr : "CIDR_BLOCK",
    svc : "SERVICE_CIDR_BLOCK",
    nsg : "NETWORK_SECURITY_GROUP"
  }

  # see https://registry.terraform.io/providers/hashicorp/oci/latest/docs/resources/core_drg_attachment
  drg_attachment_types = {
    ipsec = "IPSEC_TUNNEL",
    rpc   = "REMOTE_PEERING_CONNECTION",
    vcn   = "VCN",
    vc    = "VIRTUAL_CIRCUIT"
  }

  dest_types = {
    cidr = "CIDR_BLOCK",
    svc  = "SERVICE_CIDR_BLOCK"
  }

  #Transform the list of images in a tuple
  list_images = { for s in data.oci_core_images.this.images :
    s.display_name =>
    { id               = s.id,
      operating_system = s.operating_system
    }
  }

  release = "1.0"

  private_key    = try(file(var.private_key_path), var.private_key)
  ssh_public_key = try(file(var.ssh_pub_key_path), var.ssh_pub_key)

  ssh_public_keys = join("\n", [
    trimspace(local.ssh_public_key),
    trimspace(tls_private_key.this.public_key_openssh)
  ])

  latest_ol8_image_id = data.oci_core_images.latest_ol8.images[0].id
  compute_image_id    = try(var.compute_image_name, local.latest_ol8_image_id)
  # compute_shape = var.always_free_compute == true ? "VM.Standard.E2.1.Micro" : "VM.Standard2.1"
  compute_shape = var.compute_shape

  blender_file_name = split("/", var.blender_url)[length(split("/", var.blender_url)) - 1]
  blender_dir       = split(".tar.xz", local.blender_file_name)[0]
}