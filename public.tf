########### public ###########

variable "public_name" {
  description = "Name of Application that these VMs will be used running"
  default     = "public"
}

variable "public_vm_count" {
  description = "Number of Virtual Machines to build"
  default     = "1"
}

variable "public_vm_size" {
  description = "Specifies the size of the virtual machine."
  default     = "Standard_A1_v2"
}

resource "azurerm_availability_set" "public_avset" {
  name                         = "${var.dns_name}avset"
  location                     = "${lookup(var.zone, terraform.workspace)}"
  resource_group_name          = "${azurerm_resource_group.rg.name}"
  platform_fault_domain_count  = 2
  platform_update_domain_count = 2
  managed                      = true
}

resource "azurerm_network_interface" "public_nic" {
  name                = "${var.rg_prefix}-${var.public_name}-nic-${format("%02d", count.index+1)}"
  location            = "${lookup(var.zone, terraform.workspace)}"
  resource_group_name = "${azurerm_resource_group.rg.name}"
  network_security_group_id  =  "${azurerm_network_security_group.public_sg.id}"

  ip_configuration {
    name                          = "${var.rg_prefix}-${var.public_name}-ipconfig"
    subnet_id                     = "${azurerm_subnet.subnet_public.id}"
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = "${element(azurerm_public_ip.public_pip.*.id, count.index)}"

  }

  count = "${var.public_vm_count}"
}

resource "azurerm_public_ip" "public_pip" {
  name                         = "${var.rg_prefix}-${var.public_name}-ip-${format("%02d", count.index+1)}"
  location                     = "${lookup(var.zone, terraform.workspace)}"
  resource_group_name          = "${azurerm_resource_group.rg.name}"
  public_ip_address_allocation = "Dynamic"
  domain_name_label            = "${terraform.workspace}-${var.dns_name}"

  count = "${var.public_vm_count}"
}

resource "azurerm_managed_disk" "public_datadisk" {
  name                 = "${var.public_name}-datadisk-${format("%02d", count.index+1)}"
  location             = "${lookup(var.zone, terraform.workspace)}"
  resource_group_name  = "${azurerm_resource_group.rg.name}"
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = "10"

  count = "${var.public_vm_count}"
}

resource "azurerm_virtual_machine" "public_vm" {
  name                  = "${var.rg_prefix}-${var.public_name}vm-${format("%02d", count.index+1)}"
  location              = "${lookup(var.zone, terraform.workspace)}"
  resource_group_name   = "${azurerm_resource_group.rg.name}"
  vm_size               = "${var.public_vm_size}"
  network_interface_ids = ["${element(azurerm_network_interface.public_nic.*.id, count.index)}"]
  availability_set_id   = "${azurerm_availability_set.public_avset.id}"

  storage_image_reference {
    publisher = "${var.image_publisher}"
    offer     = "${var.image_offer}"
    sku       = "${var.image_sku}"
    version   = "${var.image_version}"
  }

  storage_os_disk {
    name              = "${var.public_name}-osdisk-${format("%02d", count.index+1)}"
    managed_disk_type = "Standard_LRS"
    caching           = "ReadWrite"
    create_option     = "FromImage"
  }

  os_profile {
    computer_name  = "${var.public_name}-${format("%02d", count.index+1)}"
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

  count = "${var.public_vm_count}"
}