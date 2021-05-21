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
  test_clusters = [
    {
      hostname                        = "abc.net"
      instances                       = 2
      scaleset_sku                    = "Standard_D3_v2"
      disable_password_authentication = true
      enable_accelerated_networking   = true
    },
    {
      hostname                        = "xyz.net"
      instances                       = 2
      scaleset_sku                    = "Standard_B2ms"
      disable_password_authentication = true
      enable_accelerated_networking   = false
    }
  ]
}

module "test_scalesets" {
  source   = "../../.."
  for_each = { for host in local.test_clusters : host.hostname => host }

  scaleset_name       = "test_scaleset_${each.key}"
  resource_group_name = module.test_rg.resource_group_name
  location            = module.test_rg.location

  instances                       = each.value.instances
  scaleset_sku                    = each.value.scaleset_sku
  admin_username                  = var.admin_username
  computer_name_prefix            = "jiranode-${each.key}"
  disable_password_authentication = each.value.disable_password_authentication
  enable_accelerated_networking   = each.value.enable_accelerated_networking

  image_offer     = "UbuntuServer"
  image_publisher = "Canonical"
  image_sku       = "18.04-LTS"
  image_version   = "latest"

  ip_config_application_gateway_backend_address_pool_ids = []
  ip_config_name                                         = "cluster_ipconfig_${each.key}"
  ip_config_subnet_id                                    = module.test_subnet.subnet_id
  network_interface_name                                 = "cluster-nic_${each.key}"

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