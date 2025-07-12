variable "virtual_network_address_space" {
  description = "The address space for the virtual network."
  type        = string
  default     = "10.0.0.0/24"
}

variable "lab_instance_id" {
  description = "The unique identifier for the lab instance."
  type        = number
  default     = 0
}
