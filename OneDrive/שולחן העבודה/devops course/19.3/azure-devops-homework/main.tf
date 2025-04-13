provider "azurerm" {
  features {}
}

resource "azurerm_log_analytics_workspace" "example" {
  name                = "devops-homework-log-analytics"
  location            = "West Europe"
  resource_group_name = "devops-homework"
  sku                  = "PerGB2018"
}

resource "azurerm_resource_group" "example" {
  name     = "devops-homework"
  location = "West Europe"
}

resource "azurerm_storage_account" "storageaccountmaor1" {
  name                     = "storageaccountmaor1"
  resource_group_name      = azurerm_resource_group.example.name
  location                 = azurerm_resource_group.example.location
  account_tier              = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_account" "storageaccountmaor2" {
  name                     = "storageaccountmaor2"
  resource_group_name      = azurerm_resource_group.example.name
  location                 = azurerm_resource_group.example.location
  account_tier              = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_virtual_machine" "maor-vm" {
  name                  = "devops-homework-vm"
  location              = azurerm_resource_group.example.location
  resource_group_name   = azurerm_resource_group.example.name
  network_interface_ids = [azurerm_network_interface.example.id]
  vm_size               = "Standard_B1ms"

  storage_os_disk {
    name              = "maor-vm-os-disk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed           = true
    disk_size_gb      = 30
  }

  os_profile {
    computer_name  = "maor-vm"
    admin_username = "azureuser"
    admin_password = "Password1234!"
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }
}

resource "azurerm_network_interface" "example" {
  name                = "devops-homework-nic"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.example.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_virtual_network" "example" {
  name                = "devops-homework-vnet"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
}

resource "azurerm_subnet" "example" {
  name                 = "devops-homework-subnet"
  resource_group_name  = azurerm_resource_group.example.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_monitor_diagnostic_setting" "vm_diag" {
  name               = "devops-homework-vm-diagnostics"
  target_resource_id = azurerm_virtual_machine.maor-vm.id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.example.id

  metric {
    category = "AllMetrics"
    enabled  = true
  }

  log {
    category = "AuditLogs"
    enabled  = true
  }
}

resource "azurerm_monitor_dashboard" "example" {
  name                = "devops-homework-dashboard"
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  tags                = {}

  dashboard {
    tiles {
      name      = "CPU Usage"
      position  = "1,1"
      resource_id = azurerm_virtual_machine.maor-vm.id
      metric {
        name       = "Percentage CPU"
        aggregation = "Average"
      }
    }

    tiles {
      name      = "Disk Usage"
      position  = "1,2"
      resource_id = azurerm_storage_account.storageaccountmaor1.id
      metric {
        name       = "Disk Read Operations/Sec"
        aggregation = "Average"
      }
    }
  }
}
