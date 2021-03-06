variable "rds_alert_prefix" {
  type = string
  default = ""
  description = "String to prefix CloudWatch alerts with to avoid naming collisions"
}

variable "db_instance_id" {
  description = "The instance ID of the RDS database instance that you want to monitor."
  type        = string
}

variable "burst_balance_threshold" {
  description = "The minimum percent of General Purpose SSD (gp2) burst-bucket I/O credits available."
  type        = string
  default     = 20
}

variable "cpu_utilization_threshold" {
  description = "The maximum percentage of CPU utilization."
  type        = string
  default     = 80
}

variable "cpu_credit_balance_threshold" {
  description = "The minimum number of CPU credits (t2 instances only) available."
  type        = string
  default     = 0
}

variable "disk_queue_depth_threshold" {
  description = "The maximum number of outstanding IOs (read/write requests) waiting to access the disk."
  type        = string
  default     = 64
}

variable "freeable_memory_threshold" {
  description = "The minimum amount of available random access memory in Byte."
  type        = string
  default     = 64000000
  # 64 Megabyte in Byte
}

variable "free_storage_space_threshold" {
  description = "The minimum amount of available storage space in Byte."
  type        = string
  default     = 2000000000
  # 2 Gigabyte in Byte
}

variable "oldest_replication_threshold" {
  description = "The maximum amount of replication lag space in Megabyte."
  type        = string
  default     = 1000
  # 1 Gigabyte in Megabyte
}

variable "swap_usage_threshold" {
  description = "The maximum amount of swap space used on the DB instance in Byte."
  type        = string
  default     = 256000000
  # 256 Megabyte in Byte
}

variable "enabled" {
  description = "Set to false to prevent the module from creating any resources"
  type        = bool
  default     = true
  # 256 Megabyte in Byte
}
