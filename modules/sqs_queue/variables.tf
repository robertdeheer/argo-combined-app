variable "queue_name" {
  type        = string
  description = "Name of the SQS queue"
}

variable "delay_seconds" {
  type        = number
  description = "Delivery delay in seconds"
}

variable "fifo_queue" {
  type        = bool
  description = "Whether this is a FIFO queue"
}

variable "max_message_size" {
  type        = number
  description = "Maximum message size in bytes"
}

variable "message_retention_seconds" {
  type        = number
  description = "Message retention period in seconds"
}

variable "visibility_timeout_seconds" {
  type        = number
  description = "Visibility timeout in seconds"
}

variable "sqs_managed_sse_enabled" {
  type        = bool
  description = "Whether SQS-managed SSE is enabled"
}