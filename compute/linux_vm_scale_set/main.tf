resource "azurerm_linux_virtual_machine_scale_set" "linux_vm_scaleset" {
  name                = var.scaleset_name
  resource_group_name = var.resource_group_name
  location            = var.location
  admin_username      = var.admin_username
  instances           = var.instances
  sku                 = var.scaleset_sku

  overprovision          = var.overprovision
  single_placement_group = var.single_placement_group
  upgrade_mode           = var.upgrade_mode

  computer_name_prefix            = var.computer_name_prefix
  disable_password_authentication = var.disable_password_authentication

  eviction_policy              = var.eviction_policy
  health_probe_id              = var.health_probe_id
  proximity_placement_group_id = var.proximity_placement_group_id

  zone_balance = var.zone_balance
  zones        = var.zone_balance ? var.zones : []


  os_disk {
    caching              = var.osdisk_caching
    storage_account_type = var.storage_account_type
    disk_size_gb         = var.disk_size_gb
  }

  dynamic "admin_ssh_key" {
    for_each = var.ssh_keys
    content {
      public_key = admin_ssh_key.value.key
      username   = admin_ssh_key.value.username
    }
  }

  source_image_reference {
    offer     = var.image_offer
    publisher = var.image_publisher
    sku       = var.image_sku
    version   = var.image_version
  }

  network_interface {
    name                          = var.network_interface_name
    enable_accelerated_networking = var.enable_accelerated_networking
    primary                       = true
    ip_configuration {
      name                                         = var.ip_config_name
      subnet_id                                    = var.ip_config_subnet_id
      primary                                      = true
      application_gateway_backend_address_pool_ids = var.ip_config_application_gateway_backend_address_pool_ids
      application_security_group_ids               = var.ip_config_application_security_group_ids
    }
  }

  custom_data = var.custom_data
  tags        = var.tags
}