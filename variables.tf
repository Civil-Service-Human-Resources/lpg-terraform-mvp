variable "resource_group" {
  description = "The name of the resource group in which to create the virtual network."
    default = "mvp"
}

variable "rg_prefix" {
  description = "The shortened abbreviation to represent your resource group that will go on the front of some resources."
  default     = "lpg"
}

variable "dns_name" {
  description = " Label for the Domain Name. Will be used to make up the FQDN. If a domain name label is specified, an A DNS record is created for the public IP in the Microsoft Azure DNS system."
  default = "lpg"
}

variable "zone" {
  type = "map"
  default = {
    "demo" = "ukwest"
    "test" = "uksouth"
    "dev" = "uksouth"
    "testbuildcluster" = "uksouth"
  }
}

variable "virtual_network_name" {
  description = "The name for the virtual network."
  default     = "vnet"
}

variable "address_space" {
  description = "The address space that is used by the virtual network. You can supply more than one address space. Changing this forces a new resource to be created."
  default     = "10.0.0.0/16"
}

variable "storage_account_tier" {
  description = "Defines the Tier of storage account to be created. Valid options are Standard and Premium."
  default     = "Standard"
}

variable "storage_replication_type" {
  description = "Defines the Replication Type to use for this storage account. Valid options include LRS, GRS etc."
  default     = "LRS"
}

variable "image_publisher" {
  description = "name of the publisher of the image (az vm image list)"
  default     = "Canonical"
}

variable "image_offer" {
  description = "the name of the offer (az vm image list)"
  default     = "UbuntuServer"
}

variable "image_sku" {
  description = "image sku to apply (az vm image list)"
  default     = "16.04-LTS"
}

variable "image_version" {
  description = "version of the image to apply (az vm image list)"
  default     = "latest"
}

variable "admin_username" {
  description = "administrator user name"
  default     = "lpg"
}

variable "key_data" {
  type = "map"
  default = {
    "test" = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDAp2bhqIZCvmAfFlY0j3vnWpZYqM1rf5pkK5jIUNv5MvFyWoMKtCvYz7asGYC57eJWThVKxd3O7EeRXTkku2AEEqoeMAcFy+zbo0dlWshG8X6+SJm17uvZwDOCYQsE2rqU8OtOKCRD16aj6L1eOUM5SM201S7kCuhgteIUkqYITo+9DogLFJek68tMmhiH90jKURVLFCWMDpocOjG59mAN9RmoHB9iDo4ExnV24ALhFXce7x4RiKy6Ri82Xda+wPy97o6Af3IjpzFv7uThtSMWuFU2+qJCqiOO1iekqRgWobFiesnMZUlPZ71ehKHDQ5dUyxmLtwJX+Et6iDfqpPIP superroot@MBP-SR1.local"
    "demo" = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDGyZ7MTiyf/1flcZJkzRJD2IRikaYyK38tWXND7nxOz6ri0WRlvxvf+HYgmuJgJOF+0tGS9Tg31+s4TzUr0uaRfMc5ITPOdpD4nbPPjDXouwNRYh+/eSf8xlMu2WrNPrFpY3s2w/2dRn43yMPz/mIqxURyDhoe3+mfAvpEjfpJbZRKO4Q44dHsZKOBf7umBWwb8BSB1H++2bpb1QBvK5lI2Dxec10wjG1u8Epay9mdXN6FNNhAjL6vhK2byQ8KTxxPinqVYmX3TGjHQnbPdpjMT+iC+fjHfyrr6hLCdoHJfP5R93X/cjaWRxEHbdcLbQdwVPYwX7C87yKo8eXKxsIx superroot@superroot.local"
    "testbuildcluster" = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQChLXffjQJbBIMsxi/SsdpfEjI5UBRna4ghRbo90FLCWe1sI6ieeODK/v8JGab2wWs2kQRQPDa73mSMZqbme6+42zlUFvIjKNXEaL2BM23z2k47mLthhiFBC7UnXntRb/8sj96HoLUjIEmZY+xIoe9IQX7pxhS4VXGKOiSKalJzNUtXqycQ56evu+J9KLE/5P3ola0RxOuqWp7LPV1rOyjf4M5N5DY2R7OJnD3cnrc4OYvfLTuvLX1mpnPRWTHSI3YtqUJdmWDsMZ7TZcTcq1ksdY2GNRjjIJ0oatCG4EStyWuq9AYYy0+w7+Q4W8MPg5zYFylTu6x+qg4BtfVctcu9 rob@rob-virtual-machine"
    "newkey" = ""
  }
}

