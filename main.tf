resource "azurerm_resource_group" "ter" {
  name = "ter-rg"
  location = "East US"
 }

resource "azurerm_virtual_network" "ter" {
  name = "tervnwk"
  address_space = ["10.0.0.0/16"]
  location = "${azurerm_resource_group.ter.location}"
  resource_group_name = "${azurerm_resource_group.ter.name}"
 }

resource "azurerm_subnet" "ter" {
  name = "tersubn"
  resource_group_name = "${azurerm_resource_group.ter.name}"
  virtual_network_name = "${azurerm_virtual_network.ter.name}"
  address_prefix = "10.0.2.0/24"
 }

resource "azurerm_network_interface" "ter" {
  name = "ternetin"
  location = "${azurerm_resource_group.ter.location}"
  resource_group_name = "${azurerm_resource_group.ter.name}"

  ip_configuration {
    name = "terconfiguration"
    subnet_id = "${azurerm_subnet.ter.id}"
    private_ip_address_allocation = "dynamic"
   }
 }

resource "azurerm_managed_disk" "ter" {
  name = "ter_datadisk_existing"
  location = "${azurerm_resource_group.ter.location}"
  resource_group_name = "${azurerm_resource_group.ter.name}"
  storage_account_type = "Standard_LRS"
  create_option = "Empty"
  disk_size_gb = "1023"
 }

resource "azurerm_virtual_machine" "ter" {
  name = "tervm"
  location = "${azurerm_resource_group.ter.location}"
  resource_group_name = "${azurerm_resource_group.ter.name}"
  network_interface_ids = ["${azurerm_network_interface.ter.id}"]
  vm_size = "Standard_DS1_v2"


  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }

   storage_os_disk {
    name              = "myosdisk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  # Optional data disks
  storage_data_disk {
    name              = "datadisk_new"
    managed_disk_type = "Standard_LRS"
    create_option     = "Empty"
    lun               = 0
    disk_size_gb      = "1023"
  }

  storage_data_disk {
    name            = "${azurerm_managed_disk.ter.name}"
    managed_disk_id = "${azurerm_managed_disk.ter.id}"
    create_option   = "Attach"
    lun             = 1
    disk_size_gb    = "${azurerm_managed_disk.ter.disk_size_gb}"
  }



  os_profile {
    computer_name = "Terraform"
    admin_username = "terraformtask"
    admin_password = "Akirah170393"
   }

  os_profile_linux_config {
    disable_password_authentication = false
  }
}

resource "azurevm_virtual_machine_extension" "ter" {
  name = "starbucks"
  location = "East US"
  resource_group_name = "${azurerm_resource_group.ter.name}"
  virtual_machine_name = "${azurerm_virtual_machine.ter.name}"
  publisher  = "Microsoft.OSTCExtensions"
  type = "CustomScriptForLinux"
  type_handler_version = "1.5"
settings = <<SETTINGS {
     "fileuris": ["
SETTINGS
}

#terraform {
    #backend "azurerm" {
     #   storage_account_name = "starbucks"
    #    container_name = "test"
   #     key = "cassandra/v01/dev/terraform.tfstate"
  #      access_key = "6c4b6b2a-56e0-4fb7-a131-cb396c70f12e"
 #   }
#}

