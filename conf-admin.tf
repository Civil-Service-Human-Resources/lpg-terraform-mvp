###### admin ######

variable "admin_name" {
  description = "Name of Application that these VMs will be used running"
  default     = "admin"
}

variable "admin_vm_count" {
  description = "Number of Virtual Machines to build"
  default     = "1"
}

variable "admin_vm_size" {
  description = "Specifies the size of the virtual machine."
  default     = "Standard_A1_v2"
}

resource "azurerm_network_interface" "admin_nic" {
  name                = "${var.rg_prefix}-${var.admin_name}-nic-${format("%02d", count.index+1)}"
  location            = "${lookup(var.zone, terraform.workspace)}"
  resource_group_name = "${azurerm_resource_group.rg.name}"

  ip_configuration {
    name                          = "${var.rg_prefix}-${var.admin_name}-ipconfig"
    subnet_id                     = "${azurerm_subnet.subnet_admin.id}"
    private_ip_address_allocation = "Dynamic"
  }
  count = "${var.admin_vm_count}"
}

resource "azurerm_managed_disk" "admin_datadisk" {
  name                 = "${var.admin_name}-appdisk-${format("%02d", count.index+1)}"
  location             = "${lookup(var.zone, terraform.workspace)}"
  resource_group_name  = "${azurerm_resource_group.rg.name}"
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = "10"

  count = "${var.admin_vm_count}"
}

resource "azurerm_virtual_machine" "admin_vm" {
  name                  = "${var.rg_prefix}-${var.admin_name}vm-${format("%02d", count.index+1)}"
  location              = "${lookup(var.zone, terraform.workspace)}"
  resource_group_name   = "${azurerm_resource_group.rg.name}"
  vm_size               = "${var.admin_vm_size}"
  network_interface_ids = ["${element(azurerm_network_interface.admin_nic.*.id, count.index)}"]

  storage_image_reference {
    publisher = "${var.image_publisher}"
    offer     = "${var.image_offer}"
    sku       = "${var.image_sku}"
    version   = "${var.image_version}"
  }

  storage_os_disk {
    name              = "${var.admin_name}-osdisk-${format("%02d", count.index+1)}"
    managed_disk_type = "Standard_LRS"
    caching           = "ReadWrite"
    create_option     = "FromImage"
  }

  storage_data_disk {
    name              = "${azurerm_managed_disk.admin_datadisk.name}"
    managed_disk_id   = "${element(azurerm_managed_disk.admin_datadisk.*.id, count.index)}"
    managed_disk_type = "Standard_LRS"
    disk_size_gb      = "10"
    create_option     = "Attach"
    lun               = 0
  }

  os_profile {
    computer_name  = "${var.admin_name}-${format("%02d", count.index+1)}"
    admin_username = "${var.admin_username}"
  }

  os_profile_linux_config {
    disable_password_authentication = true
    ssh_keys {
            path     = "/home/lpg/.ssh/authorized_keys"
            key_data = "${lookup(var.key_data, terraform.workspace)}"
        }
  }

  boot_diagnostics {
    enabled     = true
    storage_uri = "${azurerm_storage_account.stor.primary_blob_endpoint}"
  }

  count = "${var.admin_vm_count}"
}
