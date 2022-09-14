variable "storage_account_name" {
  type    = string
  default = "sameerstorage"
}

variable "storage_account_sku" {
  default = {
    tier = "Standard"
    type = "LRS"
  }
}

variable "storage_queue_name" {
  type    = string
  default = "message-queue"
}
