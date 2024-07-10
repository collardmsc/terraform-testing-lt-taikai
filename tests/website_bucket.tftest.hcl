# Call the setup module to create a random bucket prefix
run "setup_tests" {
  module {
    source = "./tests/setup"
  }
}

# Apply run block to create the bucket
run "make_bucket" {
  variables {
    bucket_name = "${run.setup_tests.bucket_prefix}-terraform-test-lt"
  }

  # Check that the bucket name is correct
  assert {
    condition = aws_s3_bucket.s3_bucket.bucket == "${run.setup_tests.bucket_prefix}-terraform-test-lt"
    error_message = "Invalid bucket name"
  }

  # Check index.html hash matches
  assert {
    condition     = aws_s3_object.index.etag == filemd5("./www/index.html")
    error_message = "Invalid eTag for index.html"
  }

   # Check error.html hash matches
  assert {
    condition     = aws_s3_object.error.etag == filemd5("./www/error.html")
    error_message = "Invalid eTag for error.html"
  }
}

run "website_returns_200" {
  command = plan
  
  module {
    source = "./tests/final"
  }

  variables {
    endpoint = run.make_bucket.website_endpoint
  }

  assert {
    condition = data.http.index.status_code == 200
    error_message = "Invalid HTTP status code"
  }
}