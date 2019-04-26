provider "vsphere" {
  user           = "root"
  password       = "admin@123"
  vsphere_server = "192.168.43.16:443"

  # If you have a self-signed cert
  allow_unverified_ssl = true
}

data "vsphere_datacenter" "dc" {
  name = "dc1"
}

data "vsphere_datastore" "datastore" {
  name          = "datastore1"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_resource_pool" "pool" {
  name          = "esxi1/Resources"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}

data "vsphere_network" "network" {
  name          = "Public Network"
  datacenter_id = "${data.vsphere_datacenter.dc.id}"
}


/*
resource "vsphere_virtual_machine" "vm1" {
  name             = "kantama-terraform-test"
  resource_pool_id = "${data.vsphere_resource_pool.pool.id}"
  datastore_id     = "${data.vsphere_datastore.datastore.id}"
  num_cpus         = 2
  memory           = 1024
  guest_id         = "ubuntu64Guest"

  network_interface {
    network_id = "${data.vsphere_network.network.id}"
  }

  disk {
    name = "disk0.vmdk"
    size = "20"
  }

  cdrom {
    datastore_id = "${data.vsphere_datastore.datastore.id}"
    path         = "ovf-data/disk-1.vmdk"
  }

}
*/

resource "vsphere_virtual_machine" "vm" {
  name             = "Ubuntu-OS"
  resource_pool_id = "${data.vsphere_resource_pool.pool.id}"
  datastore_id     = "${data.vsphere_datastore.datastore.id}"

  num_cpus = 1
  memory   = 1024
  guest_id = "ubuntu64Guest"

  ignored_guest_ips = []


  network_interface {
    network_id = "${data.vsphere_network.network.id}"
  }

  disk {
    label = "disk0"
    size = 20
  }

  cdrom {
    datastore_id = "${data.vsphere_datastore.datastore.id}"
    path         = "ubuntu-16.04.6-server-amd64.iso"

  }
}

/*
resource "vsphere_virtual_machine" "vm-clone" {
  name             = "ubuntu-clone-test"
  resource_pool_id = "${data.vsphere_resource_pool.pool.id}"
  datastore_id     = "${data.vsphere_datastore.datastore.id}"

  num_cpus = 2
  memory   = 1024
  guest_id = "ubuntu64Guest"


  network_interface {
    network_id   = "${data.vsphere_network.network.id}"
  }

  disk {
    label            = "disk0"
    size             = "20"
  }

  clone {
    template_uuid = "${data.vsphere_virtual_machine.tempate_from_ovf.id}"

    customize {
      linux_options {
        host_name = "terraform-test"
        domain    = "test.internal"
      }

      network_interface {
        ipv4_address = "10.0.0.10"
        ipv4_netmask = 24
      }

      ipv4_gateway = "10.0.0.1"
    }
  }
}*/

