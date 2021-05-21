provider "azurerm" {
  features {}
}

resource "tls_private_key" "ssh-keys" {
  algorithm = "RSA"
  rsa_bits  = 2048
}


resource "tls_private_key" "ssh-keys_1" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

module "test_rg" {
  source              = "../../../../../resource_group"
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = {}
}

module "test_net" {
  source               = "../../../../../network/virtual_network"
  address_space        = ["10.0.1.0/24"]
  dns_servers          = []
  location             = module.test_rg.location
  resource_group_name  = module.test_rg.resource_group_name
  tags                 = {}
  virtual_network_name = "test_net"
}

module "test_subnet" {
  source               = "../../../../../network/subnet"
  address_prefixes     = ["10.0.1.0/28"]
  resource_group_name  = module.test_rg.resource_group_name
  subnet_name          = "test_subnet"
  virtual_network_name = module.test_net.virtual_network_name
}

locals {
  single_jira_cluster = length(var.test_scaleset_hostnames) <= 1
}

module "test_scalesets" {
  source                          = "../../.."
  count                           = length(var.test_scaleset_hostnames)
  scaleset_name                   = "test_scaleset${local.single_jira_cluster ? "" : count.index}"
  resource_group_name             = module.test_rg.resource_group_name
  location                        = module.test_rg.location
  instances                       = var.jmp_cluster_nodes
  scaleset_sku                    = var.jmp_cluster_vm_sku
  admin_username                  = var.admin_username
  computer_name_prefix            = "jiranode-${local.single_jira_cluster ? "" : count.index}"
  disable_password_authentication = true
  enable_accelerated_networking   = false

  image_offer     = "UbuntuServer"
  image_publisher = "Canonical"
  image_sku       = "18.04-LTS"
  image_version   = "latest"

  ip_config_application_gateway_backend_address_pool_ids = []
  ip_config_name                                         = "cluster_ipconfig${local.single_jira_cluster ? "" : count.index}"
  ip_config_subnet_id                                    = module.test_subnet.subnet_id
  network_interface_name                                 = "cluster-nic${local.single_jira_cluster ? "" : count.index}"

  osdisk_caching       = "ReadWrite"
  storage_account_type = "Premium_LRS"
  disk_size_gb         = var.jmp_cluster_disk_size

  overprovision          = false
  single_placement_group = false
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
  tags         = {}
  upgrade_mode = "Manual"
}