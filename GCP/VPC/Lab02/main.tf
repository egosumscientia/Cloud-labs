provider "google" {
  project = var.project_id
  region  = var.default_region
}

module "vpc" {
  source   = "./modules/vpc"
  vpc_name = "custom-vpc"
}

module "subnet_us" {
  source  = "./modules/subnet"
  name    = "subnet-us"
  cidr    = "10.10.0.0/24"
  region  = "us-central1"
  network = module.vpc.vpc_self_link
}

module "subnet_europe" {
  source  = "./modules/subnet"
  name    = "subnet-europe"
  cidr    = "10.20.0.0/24"
  region  = "europe-west1"
  network = module.vpc.vpc_self_link
}

module "firewall" {
  source  = "./modules/firewall"
  name    = "allow-internal"
  network = module.vpc.vpc_self_link
}

module "vm_us" {
  source     = "./modules/vm"
  name       = "vm-us"
  zone       = "us-central1-a"
  subnetwork = module.subnet_us.subnet_self_link
}

module "vm_europe" {
  source     = "./modules/vm"
  name       = "vm-europe"
  zone       = "europe-west1-b"
  subnetwork = module.subnet_europe.subnet_self_link
}
