# Generate random string for unique bucket names
resource "random_id" "random" {
  byte_length = 8
}

