provider "azurerm" {
  features {}
}

module "test_rg" {
  source              = "../../../../resource_group"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = {}
}

module "test_net" {
  source               = "../../../../network/virtual_network"
  address_space        = ["10.0.1.0/24"]
  dns_servers          = []
  location             = module.test_rg.location
  resource_group_name  = module.test_rg.resource_group_name
  tags                 = {}
  virtual_network_name = "test_net"
}

module "test_subnet" {
  source               = "../../../../network/subnet"
  address_prefixes     = ["10.0.1.0/28"]
  resource_group_name  = module.test_rg.resource_group_name
  subnet_name          = "test_subnet"
  virtual_network_name = module.test_net.virtual_network_name
}

module "test_nic" {
  source                        = "../../../../network/network_interface"
  location                      = module.test_rg.location
  resource_group_name           = module.test_rg.resource_group_name
  nic_name                      = var.nic_name
  ip_configuration_name         = var.ip_configuration_name
  public_ip_address_id          = var.public_ip_address_id
  subnet_id                     = module.test_subnet.subnet_id
  private_ip_address            = var.private_ip_address
  private_ip_address_allocation = var.private_ip_address_allocation
  tags                          = {}
  depends_on                    = [module.test_subnet]
}

resource "tls_private_key" "ssh-keys" {
  algorithm = "RSA"
  rsa_bits  = 2048
}


resource "tls_private_key" "ssh-keys_1" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

module "test_vm" {
  source                          = "../.."
  resource_group_name             = module.test_rg.resource_group_name
  location                        = var.location
  vm_name                         = var.vm_name
  vm_size                         = var.vm_size
  network_interface_ids           = [module.test_nic.network_interface_id]
  admin_username                  = var.admin_username
  disable_password_authentication = true

  osdisk_caching       = "ReadWrite"
  osdisk_name          = "test-osdisk"
  disk_size_gb         = var.disk_size_gb
  storage_account_type = "Premium_LRS"

  image_offer     = "UbuntuServer"
  image_publisher = "Canonical"
  image_sku       = "18.04-LTS"
  image_version   = "latest"

  ssh_keys = [
    {
      key      = tls_private_key.ssh-keys.public_key_openssh
      username = var.admin_username
    },
    {
      key      = tls_private_key.ssh-keys_1.public_key_openssh
      username = var.admin_username
    }
  ]
  tags = {}
}