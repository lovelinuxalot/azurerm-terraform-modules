resource "azurerm_linux_virtual_machine" "linux_vm" {
  admin_username                  = var.admin_username
  location                        = var.location
  name                            = var.vm_name
  network_interface_ids           = var.network_interface_ids
  resource_group_name             = var.resource_group_name
  size                            = var.vm_size
  disable_password_authentication = var.disable_password_authentication
  availability_set_id             = var.availability_set_id

  os_disk {
    name                 = var.osdisk_name
    caching              = var.osdisk_caching
    storage_account_type = var.storage_account_type
    disk_size_gb         = var.disk_size_gb
  }
  source_image_reference {
    offer     = var.image_offer
    publisher = var.image_publisher
    sku       = var.image_sku
    version   = var.image_version
  }
  dynamic "admin_ssh_key" {
    for_each = var.ssh_keys
    content {
      public_key = admin_ssh_key.value.key
      username   = admin_ssh_key.value.username
    }
  }
  custom_data = var.custom_data
  tags        = var.tags
}