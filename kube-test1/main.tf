terraform {
  required_providers {
    libvirt = {
      source = "dmacvicar/libvirt"
    }
  }
}
provider "libvirt" {
}

locals {
    host_list = toset([ "kube_test1", "kube_test2" ])
}

resource "libvirt_volume" "volumes" {
    for_each = local.host_list
        name = "${each.key}.qcow2"
        pool = "default" 
        source = "/var/lib/libvirt/images/ubuntu_server_jammy_template2_fixed_net_30G_disk.qcow"
        format = "qcow2"
}

resource "libvirt_domain" "hosts" {
    for_each = local.host_list
        name   = each.key
        #memory = "2048"
        #memory = "4096"
        memory = "6144"
        vcpu   = 2

        network_interface {
            network_name = "host-bridge"
        }

        disk {
            volume_id = libvirt_volume.volumes[each.key].id
       }

        console {
            type = "pty"
            target_type = "serial"
            target_port = "0"
        }

        graphics {
            type = "vnc"
            listen_type = "address"
            listen_address = "0.0.0.0"
            autoport = true
        }
}


