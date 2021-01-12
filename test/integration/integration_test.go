package test

import (
	"context"
	"os"
	"testing"
	"time"

	"cloud.google.com/go/storage"
	http_helper "github.com/gruntwork-io/terratest/modules/http-helper"
	"github.com/gruntwork-io/terratest/modules/terraform"
	"github.com/stretchr/testify/assert"
)

func TestBucketGetsCreated(t *testing.T) {
	tfOptions := terraform.WithDefaultRetryableErrors(t, &terraform.Options{
		TerraformDir: "../../",
	})

	os.Setenv("GOOGLE_APPLICATION_CREDENTIALS", "../../.secrets/gcp-creds.json")

	defer terraform.Destroy(t, tfOptions)

	terraform.InitAndApply(t, tfOptions)

	cloudFunctionsURL := terraform.Output(t, tfOptions, "cloud_function_url")

	ctx := context.Background()
	client, err := storage.NewClient(ctx)
	if err != nil {
		t.Fail()
	}

	// Validate cloud function bucket
	bucket := client.Bucket("opa-test-bucket")
	attrs, err := bucket.Attrs(ctx)
	if err != nil {
		t.Fail()
	}
	assert.Equal(t, attrs.Location, "EUROPE-WEST1")

	// Test that cloud function responds
	http_helper.HttpGetWithRetry(t, cloudFunctionsURL, nil, 200, "Hello World!", 30, 5*time.Second)

}
