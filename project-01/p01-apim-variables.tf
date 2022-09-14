variable "apim_name" {
  type    = string
  default = "sameer-apim"
}

variable "apimSku" {
  type    = string
  default = "Consumption"
}

variable "apimSkuCapacity" {
  type    = number
  default = 0
}

variable "apimPublisherName" {
  type    = string
  default = "Sameer Azure Test"
}

variable "apimPublisherEmail" {
  type    = string
  default = "az.test@aztest.com"
}