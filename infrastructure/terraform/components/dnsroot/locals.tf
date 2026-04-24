locals {
  csoc_shield_bus_arn = format("arn:aws:events:%s:%s:event-bus/shield-eventbus", var.region, var.csoc_destination_account)
}