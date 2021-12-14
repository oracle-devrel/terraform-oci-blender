# Blender on OCI

## Introduction
Do you enjoy working with 3D modeling and rendering?  Maybe you'd like to play with it a little?  This is for you!  There are lots of different 3D rendering solutions out there... we chose to use Blender.  It's free/open-source, is mature (has been around the block a few times) and has a strong community (user base).  Of course, these are all non-techie reasons to use Blender... we won't be diving into any of the differentiators (that's something you can do on your own for "extra credit").  :)

If you've played with Blender (or any 3D rendering solution) before, it's usually pretty easy to install on your personal computer.  The downside is that unless you have a high-end GPU(s), rendering times can be a bit of a bummer.  Working with Blender locally can be great from a user experience perspective (modeling, scene and project setup), but the actual rendering can be... deflating... at best.

This solution allows you to quickly spin-up a single OCI Compute instance that has a GUI, VNC and Blender pre-installed for you, ready-to-go!  The beauty of this is that you can choose a lightweight, low-cost (or no-cost, if you use an Always Free Tier) shape, or you can choose a GPU powerhouse (that will cost you some money, but can really crank through a render).  The choice is yours.

## Getting Started
You must have an OCI account.  [Click here](https://www.oracle.com/cloud/free/?source=:ex:tb:::::WWMK211208P00078&SC=:ex:tb:::::WWMK211208P00078&pcode=WWMK211208P00078) to create a new cloud account.

There are a couple of options for deploying this project:
* Oracle Cloud Resource Manager
* Terraform CLI
* Oracle Cloud Shell

**NOTE:** Regardless of which deployment method you choose, make sure that you select the correct Compute Instance shape and the Compute Image to go with it (if you choose a GPU shape, make sure you choose a GPU Compute Image, etc.).  See [https://docs.oracle.com/en-us/iaas/images/](https://docs.oracle.com/en-us/iaas/images/?source=:ex:tb:::::WWMK211208P00078&SC=:ex:tb:::::WWMK211208P00078&pcode=WWMK211208P00078) for a list of available Compute Images.

**This solution was built to use Oracle Linux... if you choose a different Linux distribution, your mileage may vary (a reasonable expectation would be that it might *not* work out-of-the-box).**

It might seem odd and counter-productive to set a password for the `opc` user account. Since you'll be accessing the instance via a GUI, this password is largely available for if/when the screen might lock and you need to unlock it.

### Oracle Cloud Resource Manager
This is really easy to do!  Simply click [![Deploy to Oracle Cloud](https://oci-resourcemanager-plugin.plugins.oci.oraclecloud.com/latest/deploy-to-oracle-cloud.svg)](https://cloud.oracle.com/resourcemanager/stacks/create?region=home&zipUrl=https://github.com/oracle-devrel/terraform-oci-blender/releases/latest/download/terraform-oci-blender-orm.zip) and follow the on-screen prompts.

Make sure to apply the stack, by either checking the box during its creation or manually after it is created.

### Terraform CLI
Clone this repo:

```
git clone https://github.com/oracle-devrel/terraform-oci-blender
```

Copy `terraform.tfvars.template` to `terraform.tfvars`, then modify the contents (fill-in-the-blanks for your tenancy).

Run `terraform init`.  Review what Terraform thinks should be done by running `terraform plan` and if you're satisified with it, then run `terraform apply`.

### Oracle Cloud Shell
Follow the same directions used for Terraform CLI (above), however you'll need to modify the contents of the `provider.tf` file first.  Look at the comment blocks, commenting out the lines used for Terraform CLI and uncommenting the line(s) needed for Cloud Shell.  Once this is done, proceed with the same steps (`terraform init`, `terraform plan` and then `terraform apply` if you're happy with what it's proposing be done).

## Using Blender
Once the project is deployed, you will want to VNC to the Blender instance.  Here's what you'll want to do:

1. SSH to Blender instance (make sure to forward port `tcp/5901`)
    On MacOS, a command like `ssh opc@<pub_ip> -L 5901:localhost:5901` would work.  Note that the command is given in the outputs (available via all deployment methods).
2. Connect via VNC to Blender instance
    Use your favorite VNC viewer to connect to the Blender instance.  Because you've redirected/forwarded port 5901 from the Blender Compute Instance (you've deployed) to your local system (also on port 5901), you'll need to connect to your `localhost` on port 5901.
    
    As an example, on MacOS, you might go to `Finder` > `Go` > `Connect to Server...`, then enter the correct path (this is also provided as an output when running Terraform to deploy the project): `vnc://localhost:5901`
3. Enter your `vnc_passwd` to connect to VNC
4. Once connected via VNC, click on `Activities` > `Terminal` > type `blender` to launch Blender

Have fun with it!

### Enabling GPU Rendering
If you're using a Compute shape that has a GPU, make sure to enable GPU rendering.  From within Blender, click on Edit > Preferences > System > Cycles Render Devices = CUDA

### Prerequisites
You must have an OCI account.  [Click here](https://www.oracle.com/cloud/free/?source=:ex:tb:::::WWMK211208P00078&SC=:ex:tb:::::WWMK211208P00078&pcode=WWMK211208P00078) to create a new cloud account.


## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_oci"></a> [oci](#provider\_oci) | 4.53.0 |
| <a name="provider_oci.home"></a> [oci.home](#provider\_oci.home) | 4.53.0 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.1.0 |
| <a name="provider_tls"></a> [tls](#provider\_tls) | 3.1.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [oci_core_instance.blender](https://registry.terraform.io/providers/hashicorp/oci/latest/docs/resources/core_instance) | resource |
| [oci_core_internet_gateway.this](https://registry.terraform.io/providers/hashicorp/oci/latest/docs/resources/core_internet_gateway) | resource |
| [oci_core_network_security_group.blender](https://registry.terraform.io/providers/hashicorp/oci/latest/docs/resources/core_network_security_group) | resource |
| [oci_core_network_security_group_security_rule.outbound_https](https://registry.terraform.io/providers/hashicorp/oci/latest/docs/resources/core_network_security_group_security_rule) | resource |
| [oci_core_route_table.public](https://registry.terraform.io/providers/hashicorp/oci/latest/docs/resources/core_route_table) | resource |
| [oci_core_subnet.this](https://registry.terraform.io/providers/hashicorp/oci/latest/docs/resources/core_subnet) | resource |
| [oci_core_vcn.this](https://registry.terraform.io/providers/hashicorp/oci/latest/docs/resources/core_vcn) | resource |
| [oci_identity_tag.release](https://registry.terraform.io/providers/hashicorp/oci/latest/docs/resources/identity_tag) | resource |
| [oci_identity_tag_namespace.devrel](https://registry.terraform.io/providers/hashicorp/oci/latest/docs/resources/identity_tag_namespace) | resource |
| [random_id.tag](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) | resource |
| [tls_private_key.this](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/private_key) | resource |
| [oci_core_images.latest_ol8](https://registry.terraform.io/providers/hashicorp/oci/latest/docs/data-sources/core_images) | data source |
| [oci_core_images.this](https://registry.terraform.io/providers/hashicorp/oci/latest/docs/data-sources/core_images) | data source |
| [oci_identity_availability_domains.ads](https://registry.terraform.io/providers/hashicorp/oci/latest/docs/data-sources/identity_availability_domains) | data source |
| [oci_identity_region_subscriptions.home_region_subscriptions](https://registry.terraform.io/providers/hashicorp/oci/latest/docs/data-sources/identity_region_subscriptions) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_blender_url"></a> [blender\_url](#input\_blender\_url) | The URL for downloading Blender. | `string` | `"https://mirror.clarkson.edu/blender/release/Blender2.93/blender-2.93.6-linux-x64.tar.xz"` | no |
| <a name="input_compartment_ocid"></a> [compartment\_ocid](#input\_compartment\_ocid) | The compartment OCID to deploy resources to | `string` | `""` | no |
| <a name="input_compute_image_name"></a> [compute\_image\_name](#input\_compute\_image\_name) | The name of the compute image to use for the compute instances. | `string` | `""` | no |
| <a name="input_compute_shape"></a> [compute\_shape](#input\_compute\_shape) | See https://docs.oracle.com/en-us/iaas/Content/Compute/References/computeshapes.htm for the different compute shapes available. | `string` | `"VM.Standard2.1"` | no |
| <a name="input_fingerprint"></a> [fingerprint](#input\_fingerprint) | 'API Key' fingerprint, more details can be found at https://docs.cloud.oracle.com/en-us/iaas/Content/General/Concepts/credentials.htm#two | `string` | `""` | no |
| <a name="input_opc_passwd"></a> [opc\_passwd](#input\_opc\_passwd) | The password to use for the opc OL8 account. | `string` | n/a | yes |
| <a name="input_private_key"></a> [private\_key](#input\_private\_key) | The private key (provided as a string value) | `string` | `""` | no |
| <a name="input_private_key_password"></a> [private\_key\_password](#input\_private\_key\_password) | The password to use for the private key | `string` | `""` | no |
| <a name="input_private_key_path"></a> [private\_key\_path](#input\_private\_key\_path) | Path to private key used to create OCI 'API Key', more details can be found at https://docs.cloud.oracle.com/en-us/iaas/Content/General/Concepts/credentials.htm#two | `string` | `""` | no |
| <a name="input_region"></a> [region](#input\_region) | OCI Region as documented at https://docs.cloud.oracle.com/en-us/iaas/Content/General/Concepts/regions.htm | `string` | `"us-phoenix-1"` | no |
| <a name="input_ssh_pub_key"></a> [ssh\_pub\_key](#input\_ssh\_pub\_key) | The SSH public key contents to use for the compute instances. | `string` | `""` | no |
| <a name="input_ssh_pub_key_path"></a> [ssh\_pub\_key\_path](#input\_ssh\_pub\_key\_path) | The path to the SSH public key to use for the compute instances. | `string` | `""` | no |
| <a name="input_tenancy_ocid"></a> [tenancy\_ocid](#input\_tenancy\_ocid) | OCI tenant OCID, more details can be found at https://docs.cloud.oracle.com/en-us/iaas/Content/API/Concepts/apisigningkey.htm#five | `any` | n/a | yes |
| <a name="input_user_ocid"></a> [user\_ocid](#input\_user\_ocid) | OCI user OCID, more details can be found at https://docs.cloud.oracle.com/en-us/iaas/Content/API/Concepts/apisigningkey.htm#five | `string` | `""` | no |
| <a name="input_vnc_passwd"></a> [vnc\_passwd](#input\_vnc\_passwd) | The password to use for connecting to the VNC session. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_macos_finder_vnc_connect_string"></a> [macos\_finder\_vnc\_connect\_string](#output\_macos\_finder\_vnc\_connect\_string) | n/a |
| <a name="output_pub_ip"></a> [pub\_ip](#output\_pub\_ip) | n/a |
| <a name="output_ssh_cmd"></a> [ssh\_cmd](#output\_ssh\_cmd) | n/a |

## Notes/Issues
None at this time.

## URLs
* https://support.oracle.com/knowledge/Oracle%20Cloud/2772665_1.html?source=:ex:tb:::::WWMK211208P00078&SC=:ex:tb:::::WWMK211208P00078&pcode=WWMK211208P00078
* http://www.happymillfam.com/login-to-new-oci-linux-instance-via-console/
* https://support.oracle.com/epmos/faces/DocumentDisplay?_afrLoop=298153942357860&parent=EXTERNAL_SEARCH&sourceId=HOWTO&id=2717454.1&_afrWindowMode=0&_adf.ctrl-state=k1teolgb7_4&source=:ex:tb:::::WWMK211208P00078&SC=:ex:tb:::::WWMK211208P00078&pcode=WWMK211208P00078
* https://jeffmdavies.medium.com/blender-2-83-on-oracle-cloud-infrastructure-80ecfcb2ce4e
* https://jeffmdavies.medium.com/blender-2-83-on-oracle-cloud-infrastructure-part-2-fb9686790352
* https://jeffmdavies.medium.com/blender-2-83-on-oracle-cloud-infrastructure-part-3-95e4fda3731b

## Contributing
This project is open source.  Please submit your contributions by forking this repository and submitting a pull request!  Oracle appreciates any contributions that are made by the open source community.

## License
Copyright (c) 2021 Oracle and/or its affiliates.

Licensed under the Universal Permissive License (UPL), Version 1.0.

See [LICENSE](LICENSE) for more details.
