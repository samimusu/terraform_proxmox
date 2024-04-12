
// 別途、定数を記載し他ファイルを作成
variable "username" {}
variable "cores" {}
variable "memory" {}
variable "disk_size" {}
variable "disk_storage" {}
variable "api_token_secret" {}
variable "api_token_id" {}
variable "api_url" {}

// 2.9.13以上でcloud-initでvmをクローンするとうまく作成できないため、2.9.11を使用
terraform {
  required_providers {
    proxmox = {
      source = "Telmate/proxmox"
      version = "2.9.11"
    }
  }
}


// proxmoxに接続するための必要情報を記載
provider "proxmox" {
  # Configuration options
  pm_api_token_id = var.api_token_id
  pm_api_token_secret = var.api_token_secret
  pm_api_url = var.api_url
  pm_tls_insecure = true
}

// 作成するリソースの情報を記載
resource "proxmox_vm_qemu" "terraform-test-vm"{
    name = "tf-test-vm"
    target_node = "pve-2"
    clone = "ubuntu2204-template"
    boot = "cd"
    memory = var.memory
    cores = var.cores
    os_type = "cloud-init"
    scsihw = "virtio-scsi-single"
    agent = 1
    
    disk {
      type = "scsi"
      storage = var.disk_storage
      size = "${var.disk_size}G"
    }
    disk {
      type = "scsi"
      storage = var.disk_storage
      size = "10G"
    }
}

