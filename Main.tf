provider "azurerm" {
  features {}
}

data "azurerm_resource_group" "rg1" {
    name = "ankushrg"
}

data "azurerm_resource_group" "rg2" {
    name = "chhavirg"
}

data "azurerm_subnet" "subnet1" {
    name = subnet1
}

data "azurerm_subnet" "subnet2" {
    name = subnet2
}

resource "azurerm_route_table" "rtable1" {
  name                = "routetable1"
  location            = data.azurerm_resource_group.rg1.location
  resource_group_name = data.azurerm_resource_group.rg1.name
}

resource "azurerm_route" "route1" {
  name                   = "vm1tovm2"
  resource_group_name    = data.azurerm_resource_group.rg1.name
  route_table_name       = azurerm_route_table.rtable1.name
  address_prefix         = "192.0.0.0/16"
  next_hop_type          = "VirtualAppliance"
  next_hop_in_ip_address = "172.0.0.4"
}

resource "azurerm_subnet_route_table_association" "rt1as" {
  subnet_id       = data.azurerm_subnet.subnet1.name
  route_table_id  = azurerm_route_table.rtable1.id
}

resource "azurerm_route_table" "rtable2" {
  name                = "routetable2"
  location            = data.azurerm_resource_group.rg2.location
  resource_group_name = data.azurerm_resource_group.rg2.name
}

resource "azurerm_route" "route2" {
  name                   = "vm2tovm1"
  resource_group_name    = data.azurerm_resource_group.rg2.name
  route_table_name       = azurerm_route_table.rtable2.name
  address_prefix         = "10.0.0.0/16"
  next_hop_type          = "VirtualAppliance"
  next_hop_in_ip_address = "172.0.0.4"
}

resource "azurerm_subnet_route_table_association" "rt2as" {
  subnet_id       = data.azurerm_subnet.subnet2.name
  route_table_id  = azurerm_route_table.rtable2.id
}

terraform {
  backend "azurerm" {
    resource_group_name  = "Storagerg"
    storage_account_name = "storageaccount5591"
    container_name       = "tfstate"
    key                  = "route.terraform.tfstate"
    access_key = "9DcT8nW/iKr0v2t8bfFIfM24sfJRGva1oD4macMbw6UkSwUXYHJr0ErQzgv15oErzQebT6lpi4zl+ASt2Lfeeg=="
  }
}