resource_group_name = "test_rg_vm"
location            = "westus2"

nic_name                      = "test-nic"
ip_configuration_name         = "test-nic-ipconfig"
private_ip_address            = "10.0.1.6"
private_ip_address_allocation = "Static"

vm_name        = "test-vm"
vm_size        = "Standard_DS3_v2"
admin_username = "test-admin"