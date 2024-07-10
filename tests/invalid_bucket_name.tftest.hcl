run "invalid_bucket_name" {
  command = plan

  variables {
    bucket_name = "12"
  }

  expect_failures = [var.bucket_name]
}

// run "valid_bucket_name_length" {
//   command = plan

//   variables {
//     bucket_name = "12"

    
//   }
// }
  