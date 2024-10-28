# Create a S3 bucket
resource "aws_s3_bucket" "static_web_bucket" {
  bucket = var.bucketname
}

resource "aws_s3_bucket_ownership_controls" "bucket_ownership" {
  bucket = aws_s3_bucket.static_web_bucket.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "bucket_public" {
  bucket = aws_s3_bucket.static_web_bucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_acl" "bucket_acl" {
  depends_on = [
    aws_s3_bucket_ownership_controls.bucket_ownership,
    aws_s3_bucket_public_access_block.bucket_public,
  ]

  bucket = aws_s3_bucket.static_web_bucket.id
  acl    = "public-read"
}


resource "aws_s3_object" "object1" {
  bucket       = aws_s3_bucket.static_web_bucket.id
  key          = "index.html"
  source       = "index.html"
  acl          = "public-read"
  content_type = "text/html"
}

resource "aws_s3_object" "object2" {
  bucket       = aws_s3_bucket.static_web_bucket.id
  key          = "error.html"
  source       = "error.html"
  acl          = "public-read"
  content_type = "text/html"
}

resource "aws_s3_object" "object3" {
  bucket       = aws_s3_bucket.static_web_bucket.id
  key          = "styles.css"
  source       = "styles.css"
  acl          = "public-read"
  content_type = "text/html"
}


resource "aws_s3_bucket_website_configuration" "website" {
  bucket = aws_s3_bucket.static_web_bucket.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }

 depends_on = [ aws_s3_bucket_acl.bucket_acl ]
}


output "mywebsite"{
    value= aws_s3_bucket.static_web_bucket.website_endpoint
}