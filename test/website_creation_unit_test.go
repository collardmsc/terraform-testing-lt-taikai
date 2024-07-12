package test

import (
	"fmt"
	"strconv"
	"testing"
	"time"

	http_helper "github.com/gruntwork-io/terratest/modules/http-helper"
	"github.com/gruntwork-io/terratest/modules/random"
	"github.com/gruntwork-io/terratest/modules/terraform"
)

// An example of a unit test for the Terraform module in examples/hello-world-app
func TestWebsiteCreationUnit(t *testing.T) {
	t.Parallel()

	// A unique ID we can use to namespace all our resource names and ensure they don't clash across parallel tests
	uniqueId := strconv.Itoa(random.Random(0000, 9999))

	terraformOptions := &terraform.Options{
		// The path to where our Terraform code is located
		TerraformDir: "../",

		// Variables to pass to our Terraform code using -var options
		Vars: map[string]interface{}{
			"bucket_name": fmt.Sprintf("%s-terraform-test-lt", uniqueId),
		},
	}

	// At the end of the test, run `terraform destroy` to clean up any resources that were created
	defer terraform.Destroy(t, terraformOptions)

	// This will run `terraform init` and `terraform apply` and fail the test if there are any errors
	terraform.InitAndApply(t, terraformOptions)

	// Check that the website is working as expected
	validateWebsiteCreation(t, terraformOptions)
}

// Validate the Static Website is working
func validateWebsiteCreation(t *testing.T, terraformOptions *terraform.Options) {
	// Run `terraform output` to get the values of output variables
	url := terraform.Output(t, terraformOptions, "website_endpoint")

	// Verify the app returns a 200 OK
	expectedStatus := 200
	expectedBody := "Hello, World!"
	maxRetries := 3
	timeBetweenRetries := 3 * time.Second
	http_helper.HttpGetWithRetry(t, url, nil, expectedStatus, expectedBody, maxRetries, timeBetweenRetries)
}
