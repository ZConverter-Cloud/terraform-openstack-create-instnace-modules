terraform {
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "1.48.0"
    }
  }
}

locals {
  security_groups  = var.security_group_name != null ? flatten(formatlist(var.security_group_name)) : var.create_security_group_name != null ? flatten(formatlist(var.create_security_group_name)) : null
}

variable "cloud_platform" {
  type = string
}

variable "auth_url" {
  type = string
}

variable "application_credential_name" {
  type = string
}

variable "application_credential_id" {
  type = string
}

variable "application_credential_secret" {
  type = string
}

variable "region" {
  type = string
}

variable "vm_name" {
  type = string
}

variable "OS_name" {
  type = string
}

variable "OS_boot_size" {
  type = number
}

variable "flavor_name" {
  type = string
}

variable "create_key_pair_name" {
  type    = string
  default = null
}

variable "key_pair_name" {
  type    = string
  default = null
}

variable "ssh_public_key" {
  type    = string
  default = null
}

variable "ssh_public_key_file" {
  type    = string
  default = null
}

variable "private_network_name" {
  type = string
}

variable "external_network_name" {
  type = string
}

variable "security_group_name" {
  type    = string
  default = null
}

variable "create_security_group_name" {
  type    = string
  default = null
}

variable "create_security_group_rules" {
  type = list(object({
    direction        = optional(string, null)
    ethertype        = optional(string, null)
    protocol         = optional(string, null)
    port_range_min   = optional(string, null)
    port_range_max   = optional(string, null)
    remote_ip_prefix = optional(string, null)
  }))
  default = null
}

variable "user_data" {
  type = string
  default = null
}

variable "user_data_file_path" {
  type = string
  default = null
}

variable "volume" {
  type = list(number)
  default = []
}