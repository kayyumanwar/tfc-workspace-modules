variable "name" {}
variable "location" {}
variable "username" {}
variable "password" {}

provider "azurerm" {
  features {}
}

variable "vnet_address_spacing" {
  type = list
}

variable "subnet_address_prefixes" {
  type = list
}

module "networking" {
  source  = "app.terraform.io/AnwarTF-Lab/networking/azurerm"
  version = "0.12.2"

  name                    = var.name
  location                = var.location
  vnet_address_spacing    = var.vnet_address_spacing
  subnet_address_prefixes = var.subnet_address_prefixes
}
module "webserver" {
  source  = "app.terraform.io/AnwarTF-Lab/webserver/azurerm"
  version = "0.12.1"

  name      = var.name
  location  = var.location
  subnet_id = module.networking.subnet-ids[0]
  vm_count  = 1
  username  = var.username
  password  = var.password
}

module "appserver" {
  source  = "app.terraform.io/AnwarTF-Lab/appserver/azurerm"
  version = "0.12.1"
  
  name      = var.name
  location  = var.location
  subnet_id = module.networking.subnet-ids[1]
  vm_count  = 1
  username  = var.username
  password  = var.password
}
module "dataserver" {
  source  = "app.terraform.io/AnwarTF-Lab/dataserver/azurerm"
  version = "0.12.1"

  name      = var.name
  location  = var.location
  subnet_id = module.networking.subnet-ids[2]
  vm_count  = 1
  username  = var.username
  password  = var.password
}
