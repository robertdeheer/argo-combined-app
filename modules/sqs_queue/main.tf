resource "aws_sqs_queue" "this" {
  name                       = var.queue_name
  delay_seconds              = var.delay_seconds
  fifo_queue                 = var.fifo_queue
  max_message_size           = var.max_message_size
  message_retention_seconds  = var.message_retention_seconds
  visibility_timeout_seconds = var.visibility_timeout_seconds
  sqs_managed_sse_enabled    = var.sqs_managed_sse_enabled
}